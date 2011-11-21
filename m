Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab1KUVS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:18:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55138 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab1KUVS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:18:56 -0500
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: minyard@acm.org
Subject: Re: ipmi_watchdog: IPMI Watchdog: response: Error 80 on cmd 22
Date: Mon, 21 Nov 2011 22:18:51 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-rc2-00132-gc5e0c78; KDE/4.7.3; x86_64; ; )
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <201111191422.17555.a.miskiewicz@gmail.com> <20111121203411.GA20992@mvista.com>
In-Reply-To: <20111121203411.GA20992@mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111212218.51349.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 of November 2011, cminyard wrote:
> On Sat, Nov 19, 2011 at 02:22:17PM +0100, Arkadiusz Miśkiewicz wrote:
> > Hello,
> > 
> > I have few machines where ipmi_watchdog (from 3.0.9 kernel currently)
> > reports after some time:
> > 
> > IPMI Watchdog: response: Error 80 on cmd 22
> > 
> > In less than a week
> > # grep "Error 80 on cmd 22" /var/log/kernel |wc -l
> > 378681
> > 
> > #define IPMI_WDOG_RESET_TIMER           0x22
> > but no idea what error 80 is.
> 
> That error is a command-specific error, and it means: Attempt to start
> un-initialized watchdog
> 
> I'm guessing that the IPMI controller gets reset somehow and then thinks
> it's watchdog timer is not initialized, and thus the reset command causes
> an issue.
> 
> A fix should be pretty easy, if you get a 0x80 response from a reset,
> re-initialize the timer.
> 
> Can you try the following patch?

Seems to be working fine, thanks.

[   62.628219] IPMI Watchdog: driver initialized
[   62.709860] watchdog (2396): /proc/2396/oom_adj is deprecated, please use /proc/2396/oom_score_adj instead.

# ipmitool mc reset cold (easy reproducer of the problem)

[   76.002690] IPMI Watchdog: response: Error ff on cmd 22
[   76.002826] IPMI Watchdog: response: Error ff on cmd 22
[   76.002942] IPMI Watchdog: response: Error ff on cmd 22
[   76.003055] IPMI Watchdog: response: Error ff on cmd 22
[   76.003189] IPMI Watchdog: response: Error ff on cmd 22
[   76.003301] IPMI Watchdog: response: Error ff on cmd 22
[   77.114769] usb 1-1.2: reset full speed USB device number 3 using ehci_hcd
[   82.173475] usb 1-1.2: device descriptor read/64, error -32
[   82.343205] usb 1-1.2: device descriptor read/64, error -32
[   82.512940] usb 1-1.2: reset full speed USB device number 3 using ehci_hcd
[   82.579460] usb 1-1.2: device descriptor read/64, error -32
[   82.749201] usb 1-1.2: device descriptor read/64, error -32
[   82.918936] usb 1-1.2: reset full speed USB device number 3 using ehci_hcd
[   83.015337] IPMI Watchdog: response: Error ff on cmd 22
[   83.324851] usb 1-1.2: device not accepting address 3, error -32
[   83.391564] usb 1-1.2: reset full speed USB device number 3 using ehci_hcd
[   83.797438] usb 1-1.2: device not accepting address 3, error -32
[   83.797926] usb 1-1.2: USB disconnect, device number 3
[   83.907383] usb 1-1.2: new full speed USB device number 4 using ehci_hcd
[   83.973904] usb 1-1.2: device descriptor read/64, error -32
[   84.143638] usb 1-1.2: device descriptor read/64, error -32
[   84.313374] usb 1-1.2: new full speed USB device number 5 using ehci_hcd
[   84.380018] usb 1-1.2: device descriptor read/64, error -32
[   84.549626] usb 1-1.2: device descriptor read/64, error -32
[   84.719361] usb 1-1.2: new full speed USB device number 6 using ehci_hcd
[   85.125340] usb 1-1.2: device not accepting address 6, error -32
[   85.192002] usb 1-1.2: new full speed USB device number 7 using ehci_hcd
[   85.597929] usb 1-1.2: device not accepting address 7, error -32
[   85.598000] hub 1-1:1.0: unable to enumerate USB device on port 2
[   90.686716] usb 1-1.2: new full speed USB device number 8 using ehci_hcd
[   90.770958] usb 1-1.2: New USB device found, idVendor=0557, idProduct=2221
[   90.770961] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   90.770963] usb 1-1.2: Product: Hermon USB hidmouse Device
[   90.770965] usb 1-1.2: Manufacturer: Winbond Electronics Corp
[   90.772695] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input2
[   90.773358] generic-usb 0003:0557:2221.0003: input,hidraw0: USB HID v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.2/input0
[   90.775299] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/input/input3
[   90.775556] generic-usb 0003:0557:2221.0004: input,hidraw1: USB HID v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.2/input1
[   94.533830] IPMI Watchdog: response: Error ff on cmd 22
[  104.016238] IPMI Watchdog: response: The IPMI controller appears to have been reset, will attempt to reinitialize the watchdog timer



> 
> From 4467601416e23740fc940c31b1fffacbcb69b4a0 Mon Sep 17 00:00:00 2001
> From: Corey Minyard <cminyard@mvista.com>
> Date: Mon, 21 Nov 2011 14:26:20 -0600
> Subject: [PATCH] ipmi_watchdog: Restore settings when BMC reset
> 
> If the BMC gets reset, it will return 0x80 response errors.  In this case,
> it is probably a good idea to restore the IPMI settings.
> ---
>  drivers/char/ipmi/ipmi_watchdog.c |   41
> ++++++++++++++++++++++++++++++++++-- 1 files changed, 38 insertions(+), 3
> deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_watchdog.c
> b/drivers/char/ipmi/ipmi_watchdog.c index c2917ffa..34767a6 100644
> --- a/drivers/char/ipmi/ipmi_watchdog.c
> +++ b/drivers/char/ipmi/ipmi_watchdog.c
> @@ -139,6 +139,8 @@
>  #define IPMI_WDOG_SET_TIMER		0x24
>  #define IPMI_WDOG_GET_TIMER		0x25
> 
> +#define IPMI_WDOG_TIMER_NOT_INIT_RESP	0x80
> +
>  /* These are here until the real ones get into the watchdog.h interface.
> */ #ifndef WDIOC_GETTIMEOUT
>  #define	WDIOC_GETTIMEOUT        _IOW(WATCHDOG_IOCTL_BASE, 20, int)
> @@ -596,6 +598,7 @@ static int ipmi_heartbeat(void)
>  	struct kernel_ipmi_msg            msg;
>  	int                               rv;
>  	struct ipmi_system_interface_addr addr;
> +	int				  timeout_retries = 0;
> 
>  	if (ipmi_ignore_heartbeat)
>  		return 0;
> @@ -616,6 +619,7 @@ static int ipmi_heartbeat(void)
> 
>  	mutex_lock(&heartbeat_lock);
> 
> +restart:
>  	atomic_set(&heartbeat_tofree, 2);
> 
>  	/*
> @@ -653,7 +657,33 @@ static int ipmi_heartbeat(void)
>  	/* Wait for the heartbeat to be sent. */
>  	wait_for_completion(&heartbeat_wait);
> 
> -	if (heartbeat_recv_msg.msg.data[0] != 0) {
> +	if (heartbeat_recv_msg.msg.data[0] == IPMI_WDOG_TIMER_NOT_INIT_RESP)  {
> +		timeout_retries++;
> +		if (timeout_retries > 3) {
> +			printk(KERN_ERR PFX ": Unable to restore the IPMI"
> +			       " watchdog's settings, giving up.\n");
> +			rv = -EIO;
> +			goto out_unlock;
> +		}
> +
> +		/*
> +		 * The timer was not initialized, that means the BMC was
> +		 * probably reset and lost the watchdog information.  Attempt
> +		 * to restore the timer's info.  Note that we still hold
> +		 * the heartbeat lock, to keep a heartbeat from happening
> +		 * in this process, so must say no heartbeat to avoid a
> +		 * deadlock on this mutex.
> +		 */
> +		rv = ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
> +		if (rv) {
> +			printk(KERN_ERR PFX ": Unable to send the command to"
> +			       " set the watchdog's settings, giving up.\n");
> +			goto out_unlock;
> +		}
> +
> +		/* We might need a new heartbeat, so do it now */
> +		goto restart;
> +	} else if (heartbeat_recv_msg.msg.data[0] != 0) {
>  		/*
>  		 * Got an error in the heartbeat response.  It was already
>  		 * reported in ipmi_wdog_msg_handler, but we should return
> @@ -662,6 +692,7 @@ static int ipmi_heartbeat(void)
>  		rv = -EINVAL;
>  	}
> 
> +out_unlock:
>  	mutex_unlock(&heartbeat_lock);
> 
>  	return rv;
> @@ -922,11 +953,15 @@ static struct miscdevice ipmi_wdog_miscdev = {
>  static void ipmi_wdog_msg_handler(struct ipmi_recv_msg *msg,
>  				  void                 *handler_data)
>  {
> -	if (msg->msg.data[0] != 0) {
> +	if (msg->msg.cmd == IPMI_WDOG_RESET_TIMER &&
> +			msg->msg.data[0] == IPMI_WDOG_TIMER_NOT_INIT_RESP)
> +		printk(KERN_INFO PFX "response: The IPMI controller appears"
> +		       " to have been reset, will attempt to reinitialize"
> +		       " the watchdog timer\n");
> +	else if (msg->msg.data[0] != 0)
>  		printk(KERN_ERR PFX "response: Error %x on cmd %x\n",
>  		       msg->msg.data[0],
>  		       msg->msg.cmd);
> -	}
> 
>  	ipmi_free_recv_msg(msg);
>  }


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
