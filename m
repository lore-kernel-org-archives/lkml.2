Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab1EFTPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:15:04 -0400
Received: from imr4.ericy.com ([198.24.6.8]:46468 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505Ab1EFTPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:15:01 -0400
Subject: Re:
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Nat Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>
In-Reply-To: <1304707960-10178-1-git-send-email-natg@google.com>
References: <1304707960-10178-1-git-send-email-natg@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 6 May 2011 12:13:20 -0700
Message-ID: <1304709200.31666.498.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 14:52 -0400, Nat Gurumoorthy wrote:
> There are 3 different drivers that touch the it87 hardware registers.
> The 3 drivers have been written independently and access the it87 hardware
> registers assuming they are the only driver accessing it. This change
> attempts to serialize access to the hardware by using
> "request_muxed_region" macro defined by Alan Cox. Call to this macro
> will hold off the requestor if the resource is currently busy.
> The use of the above macro makes it possible to get rid of
> spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
> This also greatly simplifies the implementation of it87_wdt.c driver.
> 
> 01 - Changes to it87 watchdog driver to use "request_muxed_region"
>  drivers/watchdog/it8712f_wdt.c
>  drivers/watchdog/it87_wdt.c
> 
> 02 - Chages to hwmon it87 driver to use "request_muxed_region"
>  drivers/hwmon/it87.c
> 
>  drivers/hwmon/it87.c           |   14 +++-
>  drivers/watchdog/it8712f_wdt.c |   60 ++++++++++----
>  drivers/watchdog/it87_wdt.c    |  165 +++++++++++++++++++++++----------------
>  3 files changed, 152 insertions(+), 87 deletions(-)
> diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
> 
> Signed-off-by: Nat Gurumoorthy <natg@google.com>
> 
> Patch History:
> v8:
> - Return the error actually returned by superio_enter and not -EBUSY.

Hi Nat,

Your use of -EBUSY vs. the returned error code is still inconsistent,
for superio_enter() as well as for other functions returning an error
code.

Also, the following line split is really unnecessary.

-static inline void superio_enter(void)
+static inline int
+superio_enter(void)

Guenter


