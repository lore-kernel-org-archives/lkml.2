Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0LJWeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:34:19 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:59299 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab0LJWeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OyuwIbxyEj4JFcAbyeWr/HEN6bbyX0ErCKcsHEsrr5MLA3NTJDoZM+6A5V8l03BIcu
         WY+eYAamoTxsGv0X8ElJBdX3RJGRKGpjEI0GeLycFHr8+15DhiPVxj1RwdJLb8hivRKS
         RO9EFdB1LvSc+SPP4/mDliXVVgprhrOtOkEgg=
Subject: Re: [PATCH 1/2] memstick: add support for legacy memorysticks
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Aries Lee <arieslee@jmicron.com>
In-Reply-To: <s5htyinuf18.wl%tiwai@suse.de>
References: <1291862363.7792.28.camel@maxim-laptop>
	 <1291862546-10064-1-git-send-email-maximlevitsky@gmail.com>
	 <s5hipz31kh8.wl%tiwai@suse.de> <s5htyinw45f.wl%tiwai@suse.de>
	 <s5htyinuf18.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Dec 2010 00:34:07 +0200
Message-ID: <1292020447.31669.13.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 16:44 +0100, Takashi Iwai wrote:
> At Thu, 09 Dec 2010 12:56:44 +0100,
> Takashi Iwai wrote:
> > 
> > At Thu, 09 Dec 2010 08:19:47 +0100,
> > Takashi Iwai wrote:
> > > 
> > > At Thu,  9 Dec 2010 04:42:25 +0200,
> > > Maxim Levitsky wrote:
> > > > 
> > > > Based partialy on spec quotes from Alex Dubov.
> > > > 
> > > > As any code that works with user data this driver isn't recommened to use
> > > > with valuable data.
> > > > 
> > > > It tries its best though to avoid data corruption and possible damage to
> > > > the card.
> > > > 
> > > > Tested with MS DUO 64 MB card on Ricoh and Jmicron reader.
> > > > 
> > > > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > > 
> > > Oh, this is interesting.  Just now I looked for a solution for the old
> > > MS with new JMicron controllers.  (I should have checked mm tree
> > > beforehand...)
> > > 
> > > I'll give it a try and report back later.
> > 
> > I tried your patch now.
> > But got a WARNING and errors without working properly:
> > 
> > [   86.894497] WARNING: at drivers/memstick/core/ms_block.c:255 msb_run_state_machine+0x90/0xb0 [ms_block]()
> > [   86.894502] Hardware name:  
> > [   86.894504] Modules linked in: ms_block(+) nls_iso8859_1 nls_cp437 vfat fat mmc_block netconsole configfs nfs lockd nfs_acl auth_rpcgss sunrpc af_packet i915 drm_kms_helper drm i2c_algo_bit snd_pcm_oss cpufreq_conservative snd_mixer_oss cpufreq_userspace snd_seq cpufreq_powersave acpi_cpufreq mperf binfmt_misc snd_seq_device edd ipv6 fuse loop dm_mod acpiphp pci_hotplug snd_hda_codec_hdmi snd_hda_codec_idt processor rtc_cmos snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer uvcvideo video thermal thermal_sys snd rtc_core sr_mod soundcore snd_page_alloc sdhci_pci hwmon videodev cdrom r8169 rtc_lib v4l1_compat tpm_tis tpm intel_agp tpm_bios pcspkr hp_accel intel_gtt iTCO_wdt jmb38x_ms memstick sdhci mmc_core mii iTCO_vendor_support sg joydev lis3lv02d serio_raw i2c_core input_polldev output wmi container button battery ac ata_piix sd_mod crc_t10dif ehci_hcd ahci libahci libata usbcore scsi_mod ext3 jbd mbcache
> > [   86.895023] Pid: 4606, comm: modprobe Not tainted 2.6.37-rc5-test #2
> > [   86.895037] Call Trace:
> > [   86.895048]  [<f84fa460>] ? msb_run_state_machine+0x90/0xb0 [ms_block]
> > [   86.895062]  [<f84fa460>] ? msb_run_state_machine+0x90/0xb0 [ms_block]
> > [   86.895080]  [<c0241d6c>] warn_slowpath_common+0x6c/0xa0
> > [   86.895092]  [<f84fa460>] ? msb_run_state_machine+0x90/0xb0 [ms_block]
> > [   86.895105]  [<f84fc280>] ? h_msb_reset+0x0/0x90 [ms_block]
> > [   86.895118]  [<c0241dbd>] warn_slowpath_null+0x1d/0x20
> > [   86.895132]  [<f84fa460>] msb_run_state_machine+0x90/0xb0 [ms_block]
> > [   86.895151]  [<f84fa52c>] msb_reset+0xac/0x130 [ms_block]
> > [   86.895169]  [<f84fc9db>] msb_probe+0x6b/0xcc8 [ms_block]
> > [   86.895175]  [<c0337345>] ? sysfs_addrm_finish+0x15/0xc0
> > [   86.895187]  [<c0337d75>] ? sysfs_do_create_link+0xb5/0x1b0
> > [   86.895191]  [<c0337345>] ? sysfs_addrm_finish+0x15/0xc0
> > [   86.895212]  [<f92ba344>] memstick_device_probe+0x34/0x50 [memstick]
> > [   86.895228]  [<c042cbf5>] driver_probe_device+0x95/0x280
> > [   86.895233]  [<c038be9a>] ? kobject_add_internal+0xca/0x210
> > [   86.895249]  [<c0395543>] ? kvasprintf+0x43/0x60
> > [   86.895252]  [<c042ce59>] __driver_attach+0x79/0x80
> > [   86.895256]  [<c042c3d3>] bus_for_each_dev+0x53/0x80
> > [   86.895274]  [<f92ba2b0>] ? memstick_device_remove+0x0/0x50 [memstick]
> > [   86.895278]  [<c042c9f9>] driver_attach+0x19/0x20
> > [   86.895290]  [<c042cde0>] ? __driver_attach+0x0/0x80
> > [   86.895292]  [<c042bcc7>] bus_add_driver+0x197/0x280
> > [   86.895297]  [<f92ba2b0>] ? memstick_device_remove+0x0/0x50 [memstick]
> > [   86.895308]  [<c042d0f5>] driver_register+0x75/0x160
> > [   86.895313]  [<c0381f18>] ? register_blkdev+0xf8/0x130
> > [   86.895326]  [<f8234000>] ? msb_init+0x0/0x6d [ms_block]
> > [   86.895332]  [<f92ba422>] memstick_register_driver+0x12/0x20 [memstick]
> > [   86.895337]  [<f8234035>] msb_init+0x35/0x6d [ms_block]
> > [   86.895351]  [<c020112b>] do_one_initcall+0x2b/0x160
> > [   86.895365]  [<c0273943>] sys_init_module+0x93/0x1d0
> > [   86.895377]  [<c0202d98>] sysenter_do_call+0x12/0x28
> > [   86.895381] ---[ end trace 0f1b7248462dd657 ]---
> 
> This turned to be an uninitialized state field.  Trivial to fix.
> 
> > [   86.895593] ms_block: Switch to parallel failed
> > [   86.908121] ms_block: Switch to parallel failed
> > 
> > And "switch to parallel failed" continues endlessly until you unplug.
> > Also, at another time, the machine got frozen with plugging.
> 
> This was because I'm using the new JMicron chip which doesn't like
> the parallel mode.  Reverting your commented-out code for checking
> CAP_PAR4 bit makes it working.  I attach the patch below.
It is commented out because on my Jmicron, it doesn't work in serial
mode.
I fixed this in my patch series, but like I said, due to alex attitude,
I don't want to fix that code.
Probably by commenting out the code, I introduced run away recursion in
the code if switch fails.

Takashi, you are welcome to look at my version of code, the one that
Alex mostly refuses to merge.
It is located at http://gitorious.org/ricoh-kernel/ricoh-kernel
(This contains everything I did for ricoh and jmicron)
Try this code and see if MS standard works for you in parallel mode.

If it doesn't, every module contains built-in debugging, activated by
debug=1 or 2 module parameter, yet another thing Alex refused to
consider.

Best regards,
	Maxim Levitsky


> 
> Maybe it's safer to "parallel-mode-as-default" only for the old
> JMicron chip using some quirk bits, etc.
> 
> 
> thanks,
> 
> Takashi
> 
> ---
>  drivers/memstick/core/ms_block.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> --- a/drivers/memstick/core/ms_block.c
> +++ b/drivers/memstick/core/ms_block.c
> @@ -726,7 +726,7 @@
>  static int msb_reset(struct msb_data *msb, bool full)
>  {
>  
> -	/*bool was_parallel = msb->regs.param.system & MEMSTICK_SYS_PAM; */
> +	bool was_parallel = msb->regs.param.system & MEMSTICK_SYS_PAM;
>  	struct memstick_dev *card = msb->card;
>  	struct memstick_host *host = card->host;
>  	int error;
> @@ -762,8 +762,8 @@
>  	}
>  
>  	/* Set parallel mode */
> -	/* if (was_parallel) */
> -	msb_switch_to_parallel(msb);
> +	if (was_parallel)
> +		msb_switch_to_parallel(msb);
>  	return 0;
>  }
>  
> @@ -1673,7 +1673,7 @@
>  static int msb_init_card(struct memstick_dev *card)
>  {
>  	struct msb_data *msb = memstick_get_drvdata(card);
> -	/*struct memstick_host *host = card->host;*/
> +	struct memstick_host *host = card->host;
>  	struct ms_boot_page *boot_block;
>  	int error = 0, i, raw_size_in_megs;
>  
> @@ -1740,7 +1740,7 @@
>  
>  	/* Due to a bug in Jmicron driver, its serial mode barely works
>  		so we switch to parallel mode right away */
> -#if 0
> +#if 1
>  	/* Now we can switch the interface */
>  	if (host->caps & msb->caps & MEMSTICK_CAP_PAR4)
>  		msb_switch_to_parallel(msb);
> @@ -2184,6 +2184,7 @@
>  	msb = kzalloc(sizeof(struct msb_data), GFP_KERNEL);
>  	if (!msb)
>  		return -ENOMEM;
> +	msb->state = -1;
>  	memstick_set_drvdata(card, msb);
>  	msb->card = card;
>  	spin_lock_init(&msb->q_lock);


