Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2LDDcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 22:32:04 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:27304 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409Ab2LDDcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 22:32:01 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2012 22:32:01 EST
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "Lin, JM" <JM.Lin@atmel.com>
Subject: RE: [PATCH 01/11] watchdog/at91sam9_wdt: remove the file_operations
 struct
Thread-Topic: [PATCH 01/11] watchdog/at91sam9_wdt: remove the
 file_operations struct
Thread-Index: AQHNwjhvGbisdvQAqEOvnsnR/38JMJfr+TuAgBwc91A=
Date: Tue, 4 Dec 2012 03:26:26 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A01CEA1@penmbx01>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
 <1352877369-19740-2-git-send-email-wenyou.yang@atmel.com>
 <20121116135427.GJ4398@game.jcrosoft.org>
In-Reply-To: <20121116135427.GJ4398@game.jcrosoft.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {615B948E-7977-48F8-9DF1-B8BF724014BF}
x-cr-hashedpuzzle: ATFk FFJX G5xa MVyo TdPd T5DD ZUlG acrq fib3 fmgc kXy7
 lQzP oU6O q08j 0alO
 5f1s;5;bABpAG4AdQB4AC0AYQByAG0ALQBrAGUAcgBuAGUAbABAAGwAaQBzAHQAcwAuAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AdwBhAHQAYwBoAGQAbwBnAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBwAGwAYQBnAG4AaQBvAGoAQABqAGMAcgBvAHMAbwBmAHQALgBjAG8AbQA7AHcAaQBtAEAAaQBnAHUAYQBuAGEALgBiAGUA;Sosha1_v1;7;{615B948E-7977-48F8-9DF1-B8BF724014BF};dwBlAG4AeQBvAHUALgB5AGEAbgBnAEAAYQB0AG0AZQBsAC4AYwBvAG0A;Tue,
 04 Dec 2012 03:26:08
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgADAAMQAvADEAMQBdACAAdwBhAHQAYwBoAGQAbwBnAC8AYQB0ADkAMQBzAGEAbQA5AF8AdwBkAHQAOgAgAHIAZQBtAG8AdgBlACAAdABoAGUAIABmAGkAbABlAF8AbwBwAGUAcgBhAHQAaQBvAG4AcwAgAHMAdAByAHUAYwB0AA==
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB43WB5i006742

Hi JC,

> -----Original Message-----
> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com]
> Sent: 2012ƒÍ11‘¬16»’ 21:54
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; wim@iguana.be;
> linux-watchdog@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre, Nicolas; Lin,
> JM
> Subject: Re: [PATCH 01/11] watchdog/at91sam9_wdt: remove the file_operations
> struct
> 
> On 15:15 Wed 14 Nov     , Wenyou Yang wrote:
> > Remove the file_operations struct and miscdevice struct for future
> > add to use the watchdog framework.
> NACK
> 
> you break the watchdog support
> 
> you must not break the kernel suport except if it's impossible to do otherwise
> here it is no the case

Thanks.

But it is said so in the kernel document (Documentation/watchdog/convert_drivers_to_kernel_api.txt).
"the old drivers define their own file_operations for actions like open(), write()etc... These are now handled by the framework"

And the codes in these function is not used under the new framework which is implemented in the framework.
So I only make it in the separated patch to simpler.
> 
> Best Regards,
> J.

Best Regards
Wenyou Yang

> >
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> >  drivers/watchdog/at91sam9_wdt.c |  131 ---------------------------------------
> >  1 file changed, 131 deletions(-)
> >
> > diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> > index 05e1be8..549c256 100644
> > --- a/drivers/watchdog/at91sam9_wdt.c
> > +++ b/drivers/watchdog/at91sam9_wdt.c
> > @@ -18,11 +18,9 @@
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> >  #include <linux/errno.h>
> > -#include <linux/fs.h>
> >  #include <linux/init.h>
> >  #include <linux/io.h>
> >  #include <linux/kernel.h>
> > -#include <linux/miscdevice.h>
> >  #include <linux/module.h>
> >  #include <linux/moduleparam.h>
> >  #include <linux/platform_device.h>
> > @@ -31,7 +29,6 @@
> >  #include <linux/jiffies.h>
> >  #include <linux/timer.h>
> >  #include <linux/bitops.h>
> > -#include <linux/uaccess.h>
> >
> >  #include "at91sam9_wdt.h"
> >
> > @@ -102,35 +99,6 @@ static void at91_ping(unsigned long data)
> >  }
> >
> >  /*
> > - * Watchdog device is opened, and watchdog starts running.
> > - */
> > -static int at91_wdt_open(struct inode *inode, struct file *file)
> > -{
> > -	if (test_and_set_bit(0, &at91wdt_private.open))
> > -		return -EBUSY;
> > -
> > -	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
> > -	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
> > -
> > -	return nonseekable_open(inode, file);
> > -}
> > -
> > -/*
> > - * Close the watchdog device.
> > - */
> > -static int at91_wdt_close(struct inode *inode, struct file *file)
> > -{
> > -	clear_bit(0, &at91wdt_private.open);
> > -
> > -	/* stop internal ping */
> > -	if (!at91wdt_private.expect_close)
> > -		del_timer(&at91wdt_private.timer);
> > -
> > -	at91wdt_private.expect_close = 0;
> > -	return 0;
> > -}
> > -
> > -/*
> >   * Set the watchdog time interval in 1/256Hz (write-once)
> >   * Counter is 12 bit.
> >   */
> > @@ -168,101 +136,11 @@ static const struct watchdog_info at91_wdt_info = {
> >  						WDIOF_MAGICCLOSE,
> >  };
> >
> > -/*
> > - * Handle commands from user-space.
> > - */
> > -static long at91_wdt_ioctl(struct file *file,
> > -		unsigned int cmd, unsigned long arg)
> > -{
> > -	void __user *argp = (void __user *)arg;
> > -	int __user *p = argp;
> > -	int new_value;
> > -
> > -	switch (cmd) {
> > -	case WDIOC_GETSUPPORT:
> > -		return copy_to_user(argp, &at91_wdt_info,
> > -				    sizeof(at91_wdt_info)) ? -EFAULT : 0;
> > -
> > -	case WDIOC_GETSTATUS:
> > -	case WDIOC_GETBOOTSTATUS:
> > -		return put_user(0, p);
> > -
> > -	case WDIOC_KEEPALIVE:
> > -		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
> > -		return 0;
> > -
> > -	case WDIOC_SETTIMEOUT:
> > -		if (get_user(new_value, p))
> > -			return -EFAULT;
> > -
> > -		heartbeat = new_value;
> > -		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
> > -
> > -		return put_user(new_value, p);  /* return current value */
> > -
> > -	case WDIOC_GETTIMEOUT:
> > -		return put_user(heartbeat, p);
> > -	}
> > -	return -ENOTTY;
> > -}
> > -
> > -/*
> > - * Pat the watchdog whenever device is written to.
> > - */
> > -static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len,
> > -								loff_t *ppos)
> > -{
> > -	if (!len)
> > -		return 0;
> > -
> > -	/* Scan for magic character */
> > -	if (!nowayout) {
> > -		size_t i;
> > -
> > -		at91wdt_private.expect_close = 0;
> > -
> > -		for (i = 0; i < len; i++) {
> > -			char c;
> > -			if (get_user(c, data + i))
> > -				return -EFAULT;
> > -			if (c == 'V') {
> > -				at91wdt_private.expect_close = 42;
> > -				break;
> > -			}
> > -		}
> > -	}
> > -
> > -	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
> > -
> > -	return len;
> > -}
> > -
> > -/* ......................................................................... */
> > -
> > -static const struct file_operations at91wdt_fops = {
> > -	.owner			= THIS_MODULE,
> > -	.llseek			= no_llseek,
> > -	.unlocked_ioctl	= at91_wdt_ioctl,
> > -	.open			= at91_wdt_open,
> > -	.release		= at91_wdt_close,
> > -	.write			= at91_wdt_write,
> > -};
> > -
> > -static struct miscdevice at91wdt_miscdev = {
> > -	.minor		= WATCHDOG_MINOR,
> > -	.name		= "watchdog",
> > -	.fops		= &at91wdt_fops,
> > -};
> > -
> >  static int __init at91wdt_probe(struct platform_device *pdev)
> >  {
> >  	struct resource	*r;
> >  	int res;
> >
> > -	if (at91wdt_miscdev.parent)
> > -		return -EBUSY;
> > -	at91wdt_miscdev.parent = &pdev->dev;
> > -
> >  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	if (!r)
> >  		return -ENODEV;
> > @@ -277,10 +155,6 @@ static int __init at91wdt_probe(struct platform_device
> *pdev)
> >  	if (res)
> >  		return res;
> >
> > -	res = misc_register(&at91wdt_miscdev);
> > -	if (res)
> > -		return res;
> > -
> >  	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
> >  	setup_timer(&at91wdt_private.timer, at91_ping, 0);
> >  	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
> > @@ -295,10 +169,6 @@ static int __exit at91wdt_remove(struct platform_device
> *pdev)
> >  {
> >  	int res;
> >
> > -	res = misc_deregister(&at91wdt_miscdev);
> > -	if (!res)
> > -		at91wdt_miscdev.parent = NULL;
> > -
> >  	return res;
> >  }
> >
> > @@ -326,4 +196,3 @@ module_exit(at91sam_wdt_exit);
> >  MODULE_AUTHOR("Renaud CERRATO <r.cerrato@til-technologies.fr>");
> >  MODULE_DESCRIPTION("Watchdog driver for Atmel AT91SAM9x processors");
> >  MODULE_LICENSE("GPL");
> > -MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> > --
> > 1.7.9.5
> >
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
