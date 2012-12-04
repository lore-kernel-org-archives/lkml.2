Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab2LDASb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 19:18:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:47704 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab2LDASa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 19:18:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,211,1355126400"; 
   d="scan'208";a="228502384"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>, "mingo@kernel.org" <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Thread-Topic: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Thread-Index: AQHNz16n1Bxf/tNNEky0MTioxs293pgHyUPg
Date: Tue, 4 Dec 2012 00:18:28 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
References: <1354240068-9821-6-git-send-email-fenghua.yu@intel.com>
	<tip-474355fe313391de2429ae225e0fb02f67ec6c31@git.kernel.org>
 <CAE9FiQW13Ji1wGSvFKrhY5UEArHyY5bfL5Ma37SRU9uROdPYDw@mail.gmail.com>
In-Reply-To: <CAE9FiQW13Ji1wGSvFKrhY5UEArHyY5bfL5Ma37SRU9uROdPYDw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> On Fri, Nov 30, 2012 at 4:25 PM, tip-bot for Fenghua Yu
> <fenghua.yu@intel.com> wrote:
> > Commit-ID:  474355fe313391de2429ae225e0fb02f67ec6c31
> > Gitweb:
> http://git.kernel.org/tip/474355fe313391de2429ae225e0fb02f67ec6c31
> > Author:     Fenghua Yu <fenghua.yu@intel.com>
> > AuthorDate: Thu, 29 Nov 2012 17:47:43 -0800
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Fri, 30 Nov 2012 15:18:16 -0800
> >
> > x86/microcode_intel_early.c: Early update ucode on Intel's CPU
> >
> > Implementation of early update ucode on Intel's CPU.
> >
> > load_ucode_intel_bsp() scans ucode in initrd image file which is a
> cpio format
> > ucode followed by ordinary initrd image file. The binary ucode file
> is stored
> > in kernel/x86/microcode/GenuineIntel/microcode.bin in the cpio data.
> All ucode
> > patches with the same model as BSP are saved in memory. A matching
> ucode patch
> > is updated on BSP.
> >
> > load_ucode_intel_ap() reads saved ucoded patches and updates ucode on
> AP.
> >
> 
> looks like this patches do not consider that initrd could be relocated
> even 64bit.
> 
> may need to copy the ucode.bin to BRK at first. that will make code
> much simple, and later does not need to
> copy them back in free_bootmem_initrd.
> 
> aka, this patchset is not ready for 3.8 even.
> 

I will relocate saved microcode blob (mc_saved_in_initrd) after initrd is
relocated in updated patches. Thus, mc_saved_in_initrd always point to
right initrd during boot time.

Thanks.

-Fenghua
