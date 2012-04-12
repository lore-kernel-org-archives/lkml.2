Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944Ab2DLWpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:45:23 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58585 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab2DLWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:45:22 -0400
Date: Thu, 12 Apr 2012 15:45:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86, microcode: Fix sysfs warning during module
 unload
Message-ID: <20120412224517.GA22089@kroah.com>
References: <20120411163849.GE4794@alberich.amd.com>
 <20120411200601.GC12288@kroah.com>
 <20120411201053.GF18114@aftab>
 <20120412162351.GJ24549@aftab>
 <20120412163038.GL24549@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412163038.GL24549@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 06:30:38PM +0200, Borislav Petkov wrote:
> From: Andreas Herrmann <andreas.herrmann3@amd.com>
> Date: Thu, 12 Apr 2012 16:48:01 +0200
> Subject: [PATCH 1/2] x86, microcode: Fix sysfs warning during module unload on unsupported CPUs
> 
> Loading microcode driver on an unsupported CPU and subsequently
> unloading the driver causes
> 
>  WARNING: at fs/sysfs/group.c:138 mc_device_remove+0x5f/0x70 [microcode]()
>  Hardware name: 01972NG
>  sysfs group ffffffffa00013d0 not found for kobject 'cpu0'
>  Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel btusb snd_hda_codec bluetooth thinkpad_acpi rfkill microcode(-) [last unloaded: cfg80211]
>  Pid: 4560, comm: modprobe Not tainted 3.4.0-rc2-00002-g258f742 #5
>  Call Trace:
>   [<ffffffff8103113b>] ? warn_slowpath_common+0x7b/0xc0
>   [<ffffffff81031235>] ? warn_slowpath_fmt+0x45/0x50
>   [<ffffffff81120e74>] ? sysfs_remove_group+0x34/0x120
>   [<ffffffffa00000ef>] ? mc_device_remove+0x5f/0x70 [microcode]
>   [<ffffffff81331eb9>] ? subsys_interface_unregister+0x69/0xa0
>   [<ffffffff81563526>] ? mutex_lock+0x16/0x40
>   [<ffffffffa0000c3e>] ? microcode_exit+0x50/0x92 [microcode]
>   [<ffffffff8107051d>] ? sys_delete_module+0x16d/0x260
>   [<ffffffff810a0065>] ? wait_iff_congested+0x45/0x110
>   [<ffffffff815656af>] ? page_fault+0x1f/0x30
>   [<ffffffff81565ba2>] ? system_call_fastpath+0x16/0x1b
> 
> on recent kernels.
> 
> This is due to
> 
>   commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
>   (cpu: convert 'cpu' and 'machinecheck' sysdev_class to a regular
>   subsystem)
> 
> which renders
> 
>  commit 6c53cbfced048c421e4f72cb2183465f68fbc5e7
>  (x86, microcode: Correct sysdev_add error path)
> 
> useless.
> 
> See http://marc.info/?l=linux-kernel&m=133416246406478
> 
> Avoid above warning by restoring the old driver behaviour before
> commit 6c53cbfced048c421e4f72cb2183465f68fbc5e7 (x86, microcode:
> Correct sysdev_add error path)
> 
> Cc: stable@vger.kernel.org
> Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

