Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2GRQ5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:57:11 -0400
Received: from smtp-out-169.synserver.de ([212.40.185.169]:1068 "EHLO
	smtp-out-169.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2GRQ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:57:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23154
Message-ID: <5006EBD4.8010601@metafoo.de>
Date: Wed, 18 Jul 2012 19:01:08 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: olaf@aepfle.de
CC: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] led: use correct name for /sys/devices/virtual/leds/
 entries
References: <1342630156-16432-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1342630156-16432-1-git-send-email-olaf@aepfle.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 06:49 PM, olaf@aepfle.de wrote:
> From: Olaf Hering <olaf@aepfle.de>
> 
> Follow naming according to Documentation/leds/leds-class.txt:
> LED Device Naming
> Is currently of the form:
> "devicename:colour:function"
> 
> Reported during openSuSE 11.1 testing.
> https://bugzilla.novell.com/show_bug.cgi?&id=468350
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> diff --git a/drivers/leds/ledtrig-default-on.c b/drivers/leds/ledtrig-default-on.c
> index a4ef54b..2efdd30 100644
> --- a/drivers/leds/ledtrig-default-on.c
> +++ b/drivers/leds/ledtrig-default-on.c
> @@ -23,7 +23,7 @@ static void defon_trig_activate(struct led_classdev *led_cdev)
>  }
>  
>  static struct led_trigger defon_led_trigger = {
> -	.name     = "default-on",
> +	.name     = "default::on",
>  	.activate = defon_trig_activate,
>  };
>  

That's a LED trigger, not a LED. So the LED naming convention doesn't apply
here and it does not even make sense to try to apply it. Also the patch
breaks all users of the default-on trigger.

- Lars
