Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab0KRV16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:27:58 -0500
Received: from www.tglx.de ([62.245.132.106]:58464 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759943Ab0KRV15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:27:57 -0500
Date: Thu, 18 Nov 2010 22:27:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@linux.intel.com>
cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Feng Tang <feng.tang@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: platform: mrst: check platform_device_register()
 return code
In-Reply-To: <20101118201808.06731611@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1011182224590.2900@localhost6.localdomain6>
References: <1290104207-31279-1-git-send-email-segoon@openwall.com> <20101118181814.290811f0@linux.intel.com> <20101118184419.GA31886@albatros> <20101118201808.06731611@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Alan Cox wrote:
> On Thu, 18 Nov 2010 21:44:21 +0300
> Vasiliy Kulikov <segoon@openwall.com> wrote:
> 
> > On Thu, Nov 18, 2010 at 18:18 +0000, Alan Cox wrote:
> > > >  I cannot compile this driver in next-20101117, so it is not
> > > > tested at all.
> > > 
> > > Compile or test - if it bombs out compiling for you please send me
> > > (off list the .config that fails so I can fix that
> > > 
> > > Otherwise NAK the patch because it needs to do the cleanup but
> > > thanks for finding the bug - you've done the hard 99%
> > 
> > make -C /home/vasya/linux arch/x86/platform/mrst/vrtc.o
> > make: Entering directory `/home/vasya/dev/linux-next'
> >   CHK     include/linux/version.h
> >   CHK     include/generated/utsrelease.h
> >   CALL    scripts/checksyscalls.sh
> >   CC      arch/x86/platform/mrst/vrtc.o
> > arch/x86/platform/mrst/vrtc.c: In function 'mrst_rtc_init':
> > arch/x86/platform/mrst/vrtc.c:113: error: 'FIX_LNW_VRTC' undeclared
> > (first use in this function) arch/x86/platform/mrst/vrtc.c:113:
> > error: (Each undeclared identifier is reported only once
> > arch/x86/platform/mrst/vrtc.c:113: error: for each function it
> > appears in.) make[1]: *** [arch/x86/platform/mrst/vrtc.o] Error 1
> > 
> > Both with allyesconfig and allmodconfig, x86_64.
> 
> I can't duplicate this.
> 
> It's defined if CONFIG_X86_MRST is defined, and the file in question is
> only compiled if CONFIG_X86_MRST is defined

Of course you can't duplicate this:

> > make -C /home/vasya/linux arch/x86/platform/mrst/vrtc.o

Vasiliy forced a manual compile of that file with a 64bit config which has
CONFIG_X86_MRST=n. That's PEBKAC not a build failure :)

Thanks,

	tglx
