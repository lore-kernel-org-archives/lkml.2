Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab0GJAJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:09:45 -0400
Received: from kroah.org ([198.145.64.141]:44572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab0GJAJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:09:44 -0400
Date: Fri, 9 Jul 2010 16:57:44 -0700
From: Greg KH <greg@kroah.com>
To: Michael Leun <lkml20100708@newton.leun.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs bug when using tun with network namespaces
Message-ID: <20100709235744.GA12752@kroah.com>
References: <loom.20100708T183152-326@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20100708T183152-326@post.gmane.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 04:40:09PM +0000, Michael Leun wrote:
> Hello,
> 
> > # tunctl -u ml -t tap1
> 
> works as expected, but
> 
> > # unshare -n /bin/bash
> > # tunctl -u ml -t tap1
> 
> Jul  8 18:03:59 doris kernel: ------------[ cut here ]------------
> Jul  8 18:03:59 doris kernel: kernel BUG at fs/sysfs/file.c:540!
> Jul  8 18:03:59 doris kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
> Jul  8 18:03:59 doris kernel: last sysfs file: /sys/devices/virtual/misc/tun/dev
> Jul  8 18:03:59 doris kernel: Modules linked in: tun snd_pcm_oss snd_mixer_oss
> snd_seq snd_seq_device vboxnetadp vboxnetflt vboxdrv ipv6 cpufreq_conservative
> cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib
> freq_table ipt_REJECT ipt_LOG xt_limit xt_recent xt_state xt_tcpudp
> iptable_mangle iptable_nat iptable_filter nf_nat_ftp nf_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack ip_tables x_tables fuse nls_utf8
> loop snd_hda_codec_realtek arc4 snd_hda_intel ecb snd_hda_codec iwlagn snd_pcm
> iwlcore snd_timer mac80211 snd cfg80211 soundcore intel_agp video usb_storage
> agpgart i2c_i801 rfkill snd_page_alloc output button battery ac joydev sg evdev
> tg3 edd ext4 jbd2 crc16 sha256_generic aes_i586 aes_generic cbc dm_crypt linear
> rtc_cmos uhci_hcd rtc_core rtc_lib sd_mod crc_t10dif ehci_hcd usbcore
> dm_snapshot dm_mod fan processor thermal [last unloaded: tun]
> Jul  8 18:03:59 doris kernel:
> Jul  8 18:03:59 doris kernel: Pid: 4320, comm: tunctl Not tainted 2.6.34.1 #3
> Kuril                           /40684JG         

Network namespaces didn't go in until 2.6.35-rc, how is this working on
.34.1?

Can you verify this works properly in .35-rc4?

thanks,

greg k-h
