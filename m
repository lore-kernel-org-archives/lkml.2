Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121Ab2DKUGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:06:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53445 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2DKUGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:06:06 -0400
Date: Wed, 11 Apr 2012 13:06:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: x86, microcode: Conversion from sysdev class caused regression
Message-ID: <20120411200601.GC12288@kroah.com>
References: <20120411163849.GE4794@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411163849.GE4794@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:38:50PM +0200, Andreas Herrmann wrote:
> Hi,
> 
> commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639 (cpu: convert 'cpu'
> and 'machinecheck' sysdev_class to a regular subsystem) causes a
> regression in the CPU microcode loader.
> 
> Previous behaviour was that module loading failed if no appropriate
> CPU was found. Now we get
> 
>  [  131.717212] WARNING: at fs/sysfs/group.c:138 mc_device_remove+0x5f/0x70 [microcode]()
>  [  131.717218] Hardware name: 01972NG
>  [  131.717223] sysfs group ffffffffa00013d0 not found for kobject 'cpu0'
>  [  131.717228] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel
>                 btusb snd_hda_codec bluetooth thinkpad_acpi rfkill microcode(-) [last unloaded: cfg80211]
>  [  131.717254] Pid: 4560, comm: modprobe Not tainted 3.4.0-rc2-00002-g258f742 #5
>  [  131.717260] Call Trace:
>  [  131.717277]  [<ffffffff8103113b>] ? warn_slowpath_common+0x7b/0xc0
>  [  131.717287]  [<ffffffff81031235>] ? warn_slowpath_fmt+0x45/0x50
>  [  131.717300]  [<ffffffff81120e74>] ? sysfs_remove_group+0x34/0x120
>  [  131.717311]  [<ffffffffa00000ef>] ? mc_device_remove+0x5f/0x70 [microcode]
>  [  131.717325]  [<ffffffff81331eb9>] ? subsys_interface_unregister+0x69/0xa0
>  [  131.717336]  [<ffffffff81563526>] ? mutex_lock+0x16/0x40
>  [  131.717346]  [<ffffffffa0000c3e>] ? microcode_exit+0x50/0x92 [microcode]
>  [  131.717357]  [<ffffffff8107051d>] ? sys_delete_module+0x16d/0x260
>  [  131.717369]  [<ffffffff810a0065>] ? wait_iff_congested+0x45/0x110
>  [  131.717379]  [<ffffffff815656af>] ? page_fault+0x1f/0x30
>  [  131.717389]  [<ffffffff81565ba2>] ? system_call_fastpath+0x16/0x1b
> 
> 
> after loading the driver on an unsupported CPU and the subsequent
> attempt to unload the driver.

That's not nice, but why is the driver getting loaded for a CPU that it
doesn't control?  Startup scripts?

It's just a "warning", everything else still works properly, right?

Patches to fix this up are always gladly accepted :)

thanks,

greg k-h
