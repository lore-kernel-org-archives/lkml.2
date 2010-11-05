Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0KEDAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:00:16 -0400
Received: from imr4.ericy.com ([198.24.6.8]:52799 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab0KEDAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:00:14 -0400
Date: Thu, 4 Nov 2010 19:59:33 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 6/8] hwmon: applesmc: Dynamic creation of
 fan files
Message-ID: <20101105025933.GE28308@ericsson.com>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
 <1288511434-5662-7-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288511434-5662-7-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 03:50:32AM -0400, Henrik Rydberg wrote:
> With the dynamic temperature group in place, the setup of fans
> can be simplified. This patch sets up the fans dynamically, removing
> a hundred lines of code.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Hi Henrik,

just one minor comment.

> ---
>  drivers/hwmon/applesmc.c |  188 +++++++++++-----------------------------------
>  1 files changed, 43 insertions(+), 145 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index abbff0b..4ba20ec 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
[ ... ]

>  static int applesmc_init_smcreg_try(void)
>  {
>         struct applesmc_registers *s = &smcreg;
> +       u8 tmp[4];

Why tmp[4] if you only read one byte ?

Guenter

