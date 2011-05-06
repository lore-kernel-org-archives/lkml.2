Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1EFUAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:00:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab1EFUAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZLxfbZCYWhhCNwUaNqtt77tAMljrRvDW8oOOE/k4vjyZUORU0MicdTW1xVUXnD8y+e
         +MQwE2M8h4HEh48mBimw==
MIME-Version: 1.0
In-Reply-To: <1304709200.31666.498.camel@groeck-laptop>
References: <1304707960-10178-1-git-send-email-natg@google.com>
	<1304709200.31666.498.camel@groeck-laptop>
Date: Fri, 6 May 2011 13:00:20 -0700
Message-ID: <BANLkTikL+HSnR2L6WKZ-QH5RieMMAdbpNA@mail.gmail.com>
Subject: Re:
From: Natarajan Gurumoorthy <natg@google.com>
To: guenter.roeck@ericsson.com
Cc: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,
    Good catch. Forgot to checkin drivers/hwmon/it87.c. Also found a
couple of places I missed in driver/watch/it8712_wdt.c. Patch #9 will
be shipped later tonight. Got pulled off to do something else. Expect
patch late tonight.

Regards
Nat


On Fri, May 6, 2011 at 12:13 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> On Fri, 2011-05-06 at 14:52 -0400, Nat Gurumoorthy wrote:
>> There are 3 different drivers that touch the it87 hardware registers.
>> The 3 drivers have been written independently and access the it87 hardware
>> registers assuming they are the only driver accessing it. This change
>> attempts to serialize access to the hardware by using
>> "request_muxed_region" macro defined by Alan Cox. Call to this macro
>> will hold off the requestor if the resource is currently busy.
>> The use of the above macro makes it possible to get rid of
>> spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
>> This also greatly simplifies the implementation of it87_wdt.c driver.
>>
>> 01 - Changes to it87 watchdog driver to use "request_muxed_region"
>>  drivers/watchdog/it8712f_wdt.c
>>  drivers/watchdog/it87_wdt.c
>>
>> 02 - Chages to hwmon it87 driver to use "request_muxed_region"
>>  drivers/hwmon/it87.c
>>
>>  drivers/hwmon/it87.c           |   14 +++-
>>  drivers/watchdog/it8712f_wdt.c |   60 ++++++++++----
>>  drivers/watchdog/it87_wdt.c    |  165 +++++++++++++++++++++++----------------
>>  3 files changed, 152 insertions(+), 87 deletions(-)
>> diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
>>
>> Signed-off-by: Nat Gurumoorthy <natg@google.com>
>>
>> Patch History:
>> v8:
>> - Return the error actually returned by superio_enter and not -EBUSY.
>
> Hi Nat,
>
> Your use of -EBUSY vs. the returned error code is still inconsistent,
> for superio_enter() as well as for other functions returning an error
> code.
>
> Also, the following line split is really unnecessary.
>
> -static inline void superio_enter(void)
> +static inline int
> +superio_enter(void)
>
> Guenter
>
>
>



-- 
Regards
Nat Gurumoorthy AB6SJ
