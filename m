Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2LVNZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 08:25:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30632 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LVNZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 08:25:34 -0500
Date: Sat, 22 Dec 2012 08:25:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
Message-ID: <20121222132517.GC2936@phenom.dumpdata.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
 <20121222024225.GG3468@phenom.dumpdata.com>
 <CAE9FiQV2HU+OpYmGH3Ttn103+-s=KgdokXGroZgooMSGMPJbsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV2HU+OpYmGH3Ttn103+-s=KgdokXGroZgooMSGMPJbsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 02:38:29AM -0800, Yinghai Lu wrote:
> On Fri, Dec 21, 2012 at 6:42 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Mon, Dec 17, 2012 at 11:15:32PM -0800, Yinghai Lu wrote:
> >> Now we have limit kdump reseved under 896M, because kexec has the limitation.
> >> and also bzImage need to stay under 4g.
> >>
> >> To make kexec/kdump could use range above 4g, we need to make bzImage and
> >> ramdisk could be loaded above 4g.
> >> During booting bzImage will be unpacked on same postion and stay high.
> >>
> >> The patches add fields in setup_header and boot_params to
> >> 1. get info about ramdisk position info above 4g from bootloader/kexec
> >> 2. get info about cmd_line_ptr info above 4g from bootloader/kexec
> >> 3. set xloadflags bit0 in header for bzImage and bootloader/kexec load
> >>    could check that to decide if it could to put bzImage high.
> >> 4. use sentinel to make sure ext_* fields in boot_params could be used.
> >>
> >> This patches is tested with kexec tools with local changes and they are sent
> >> to kexec list later.
> >>
> >> could be found at:
> >>
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot
> >
> > Did a light test and it looks to work under Xen - thought I had not tested
> > any various configuration of memory layouts.
> >
> > More worryingly it blew up under native under an Dell T105 AMD box with 4GB of memory.
> > I can't get it even to print anything on the serial log:
> 
> can you try that branch again ? update the #PF handler to clean
> init_level4_pgt in all case.

Sure. Building and will email out the results shortly.
> 
> I did not consider when you are xen enabled kernel on bare metal.

As in 'CONFIG_PARAVIRT_OPS' enabled?
> 
> aka need to add
>           clear_page(init_level4_pgt);
> 
> in init_mapping_kernel() of head_64.S
> 
> Thanks
> 
> Yinghai
