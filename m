Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273Ab0KRUiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:38:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:6787 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758148Ab0KRUiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:38:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,218,1288594800"; 
   d="scan'208";a="628160786"
Date: Thu, 18 Nov 2010 20:18:08 +0000
From: Alan Cox <alan@linux.intel.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Feng Tang <feng.tang@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: platform: mrst: check
 platform_device_register() return code
Message-ID: <20101118201808.06731611@linux.intel.com>
In-Reply-To: <20101118184419.GA31886@albatros>
References: <1290104207-31279-1-git-send-email-segoon@openwall.com>
	<20101118181814.290811f0@linux.intel.com>
	<20101118184419.GA31886@albatros>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 21:44:21 +0300
Vasiliy Kulikov <segoon@openwall.com> wrote:

> On Thu, Nov 18, 2010 at 18:18 +0000, Alan Cox wrote:
> > >  I cannot compile this driver in next-20101117, so it is not
> > > tested at all.
> > 
> > Compile or test - if it bombs out compiling for you please send me
> > (off list the .config that fails so I can fix that
> > 
> > Otherwise NAK the patch because it needs to do the cleanup but
> > thanks for finding the bug - you've done the hard 99%
> 
> make -C /home/vasya/linux arch/x86/platform/mrst/vrtc.o
> make: Entering directory `/home/vasya/dev/linux-next'
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC      arch/x86/platform/mrst/vrtc.o
> arch/x86/platform/mrst/vrtc.c: In function 'mrst_rtc_init':
> arch/x86/platform/mrst/vrtc.c:113: error: 'FIX_LNW_VRTC' undeclared
> (first use in this function) arch/x86/platform/mrst/vrtc.c:113:
> error: (Each undeclared identifier is reported only once
> arch/x86/platform/mrst/vrtc.c:113: error: for each function it
> appears in.) make[1]: *** [arch/x86/platform/mrst/vrtc.o] Error 1
> 
> Both with allyesconfig and allmodconfig, x86_64.

I can't duplicate this.

It's defined if CONFIG_X86_MRST is defined, and the file in question is
only compiled if CONFIG_X86_MRST is defined



