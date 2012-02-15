Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2BOUJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:09:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35648 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2BOUJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:09:13 -0500
Date: Wed, 15 Feb 2012 13:09:10 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Ming Lei <tom.leiming@gmail.com>
Cc: balbi@ti.com, Linus Walleij <linus.walleij@stericsson.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Possible circular locking dependency (3.3-rc2)
Message-ID: <20120215200910.GE25779@ponder.secretlab.ca>
References: <20120208124147.GF16334@legolas.emea.dhcp.ti.com>
 <CACVXFVMfmabcH57da-prx=J950KEoFtfb-zsuBWn7VY3NaMUUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVMfmabcH57da-prx=J950KEoFtfb-zsuBWn7VY3NaMUUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe, can you confirm whether or not Ming's patch below solves your
problem?

g.

On Mon, Feb 13, 2012 at 10:53:20PM +0800, Ming Lei wrote:
> Hi,
> 
> On Wed, Feb 8, 2012 at 8:41 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi guys,
> >
> > I have just triggered the folllowing:
> >
> > [   84.860321] ======================================================
> > [   84.860321] [ INFO: possible circular locking dependency detected ]
> > [   84.860321] 3.3.0-rc2-00026-ge4e8a39 #474 Not tainted
> > [   84.860321] -------------------------------------------------------
> > [   84.860321] bash/949 is trying to acquire lock:
> > [   84.860321]  (sysfs_lock){+.+.+.}, at: [<c0275358>] gpio_value_store+0x24/0xcc
> > [   84.860321]
> > [   84.860321] but task is already holding lock:
> > [   84.860321]  (s_active#22){++++.+}, at: [<c016996c>] sysfs_write_file+0xdc/0x184
> > [   84.911468]
> > [   84.911468] which lock already depends on the new lock.
> > [   84.911468]
> > [   84.920043]
> > [   84.920043] the existing dependency chain (in reverse order) is:
> > [   84.920043]
> > [   84.927886] -> #1 (s_active#22){++++.+}:
> > [   84.927886]        [<c008f640>] check_prevs_add+0xdc/0x150
> > [   84.927886]        [<c008fc18>] validate_chain.clone.24+0x564/0x694
> > [   84.927886]        [<c0090cdc>] __lock_acquire+0x49c/0x980
> > [   84.951660]        [<c0091838>] lock_acquire+0x98/0x100
> > [   84.951660]        [<c016a8e8>] sysfs_deactivate+0xb0/0x100
> > [   84.962982]        [<c016b1b4>] sysfs_addrm_finish+0x2c/0x6c
> > [   84.962982]        [<c016b8bc>] sysfs_remove_dir+0x84/0x98
> > [   84.962982]        [<c02590d8>] kobject_del+0x10/0x78
> > [   84.974670]        [<c02c29e8>] device_del+0x140/0x170
> > [   84.974670]        [<c02c2a24>] device_unregister+0xc/0x18
> > [   84.985382]        [<c0276894>] gpio_unexport+0xbc/0xdc
> > [   84.985382]        [<c02768c8>] gpio_free+0x14/0xfc
> > [   85.001708]        [<c0276a28>] unexport_store+0x78/0x8c
> > [   85.001708]        [<c02c5af8>] class_attr_store+0x18/0x24
> > [   85.007293]        [<c0169990>] sysfs_write_file+0x100/0x184
> > [   85.018981]        [<c0109d48>] vfs_write+0xb4/0x148
> > [   85.018981]        [<c0109fd0>] sys_write+0x40/0x70
> > [   85.018981]        [<c0013cc0>] ret_fast_syscall+0x0/0x3c
> > [   85.035003]
> > [   85.035003] -> #0 (sysfs_lock){+.+.+.}:
> > [   85.035003]        [<c008f54c>] check_prev_add+0x680/0x698
> > [   85.035003]        [<c008f640>] check_prevs_add+0xdc/0x150
> > [   85.052093]        [<c008fc18>] validate_chain.clone.24+0x564/0x694
> > [   85.052093]        [<c0090cdc>] __lock_acquire+0x49c/0x980
> > [   85.052093]        [<c0091838>] lock_acquire+0x98/0x100
> > [   85.069885]        [<c047e280>] mutex_lock_nested+0x3c/0x2f4
> > [   85.069885]        [<c0275358>] gpio_value_store+0x24/0xcc
> > [   85.069885]        [<c02c18dc>] dev_attr_store+0x18/0x24
> > [   85.087158]        [<c0169990>] sysfs_write_file+0x100/0x184
> > [   85.087158]        [<c0109d48>] vfs_write+0xb4/0x148
> > [   85.098297]        [<c0109fd0>] sys_write+0x40/0x70
> > [   85.098297]        [<c0013cc0>] ret_fast_syscall+0x0/0x3c
> > [   85.109069]
> > [   85.109069] other info that might help us debug this:
> > [   85.109069]
> > [   85.117462]  Possible unsafe locking scenario:
> > [   85.117462]
> > [   85.117462]        CPU0                    CPU1
> > [   85.128417]        ----                    ----
> > [   85.128417]   lock(s_active#22);
> > [   85.128417]                                lock(sysfs_lock);
> > [   85.128417]                                lock(s_active#22);
> > [   85.142486]   lock(sysfs_lock);
> > [   85.151794]
> > [   85.151794]  *** DEADLOCK ***
> > [   85.151794]
> > [   85.151794] 2 locks held by bash/949:
> > [   85.158020]  #0:  (&buffer->mutex){+.+.+.}, at: [<c01698b8>] sysfs_write_file+0x28/0x184
> > [   85.170349]  #1:  (s_active#22){++++.+}, at: [<c016996c>] sysfs_write_file+0xdc/0x184
> > [   85.170349]
> > [   85.178588] stack backtrace:
> > [   85.178588] [<c001b824>] (unwind_backtrace+0x0/0xf0) from [<c008de64>] (print_circular_bug+0x100/0x114)
> > [   85.193023] [<c008de64>] (print_circular_bug+0x100/0x114) from [<c008f54c>] (check_prev_add+0x680/0x698)
> > [   85.193023] [<c008f54c>] (check_prev_add+0x680/0x698) from [<c008f640>] (check_prevs_add+0xdc/0x150)
> > [   85.212524] [<c008f640>] (check_prevs_add+0xdc/0x150) from [<c008fc18>] (validate_chain.clone.24+0x564/0x694)
> > [   85.212524] [<c008fc18>] (validate_chain.clone.24+0x564/0x694) from [<c0090cdc>] (__lock_acquire+0x49c/0x980)
> > [   85.233306] [<c0090cdc>] (__lock_acquire+0x49c/0x980) from [<c0091838>] (lock_acquire+0x98/0x100)
> > [   85.233306] [<c0091838>] (lock_acquire+0x98/0x100) from [<c047e280>] (mutex_lock_nested+0x3c/0x2f4)
> > [   85.242614] [<c047e280>] (mutex_lock_nested+0x3c/0x2f4) from [<c0275358>] (gpio_value_store+0x24/0xcc)
> > [   85.261840] [<c0275358>] (gpio_value_store+0x24/0xcc) from [<c02c18dc>] (dev_attr_store+0x18/0x24)
> > [   85.261840] [<c02c18dc>] (dev_attr_store+0x18/0x24) from [<c0169990>] (sysfs_write_file+0x100/0x184)
> > [   85.271240] [<c0169990>] (sysfs_write_file+0x100/0x184) from [<c0109d48>] (vfs_write+0xb4/0x148)
> > [   85.290008] [<c0109d48>] (vfs_write+0xb4/0x148) from [<c0109fd0>] (sys_write+0x40/0x70)
> > [   85.298400] [<c0109fd0>] (sys_write+0x40/0x70) from [<c0013cc0>] (ret_fast_syscall+0x0/0x3c)
> > -bash: echo: write error: Operation not permitted
> >
> > the way to trigger is:
> >
> >
> > root@legolas:~# cd /sys/class/gpio/
> > root@legolas:/sys/class/gpio# echo 2 > export
> > root@legolas:/sys/class/gpio# echo 2 > unexport
> > root@legolas:/sys/class/gpio# echo 2 > export
> > root@legolas:/sys/class/gpio# cd gpio2/
> > root@legolas:/sys/class/gpio/gpio2# echo 1 > value
> 
> Looks 'sysfs_lock' needn't to be held for unregister, so the patch below may
> fix the problem.
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 17fdf4b..d773540 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -873,6 +873,7 @@ void gpio_unexport(unsigned gpio)
>  {
>  	struct gpio_desc	*desc;
>  	int			status = 0;
> +	struct device		*dev = NULL;
> 
>  	if (!gpio_is_valid(gpio)) {
>  		status = -EINVAL;
> @@ -884,19 +885,20 @@ void gpio_unexport(unsigned gpio)
>  	desc = &gpio_desc[gpio];
> 
>  	if (test_bit(FLAG_EXPORT, &desc->flags)) {
> -		struct device	*dev = NULL;
> 
>  		dev = class_find_device(&gpio_class, NULL, desc, match_export);
>  		if (dev) {
>  			gpio_setup_irq(desc, dev, 0);
>  			clear_bit(FLAG_EXPORT, &desc->flags);
> -			put_device(dev);
> -			device_unregister(dev);
>  		} else
>  			status = -ENODEV;
>  	}
> 
>  	mutex_unlock(&sysfs_lock);
> +	if (dev) {
> +		device_unregister(dev);
> +		put_device(dev);
> +	}
>  done:
>  	if (status)
>  		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
> 
> 
> thanks,
> -- 
> Ming Lei
