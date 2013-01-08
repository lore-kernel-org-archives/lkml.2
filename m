Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3AHUKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:10:38 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55133 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3AHUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:10:37 -0500
Date: Tue, 8 Jan 2013 15:04:33 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v5 00/12] x86/microcode: Early load microcode
Message-ID: <20130108200432.GE15194@phenom.dumpdata.com>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
 <20130103174455.GA7350@localhost.localdomain>
 <50E5C47B.6060707@zytor.com>
 <20130108194633.GA15194@phenom.dumpdata.com>
 <50EC77DB.6090300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EC77DB.6090300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 11:47:39AM -0800, H. Peter Anvin wrote:
> On 01/08/2013 11:46 AM, Konrad Rzeszutek Wilk wrote:
> > 
> > OK. I am trying to figure out whether this usage of native_* for the
> > MSRs was done on purpose - and it sounds like the answer is no. If so -
> > can it be done using the normal 'safe_rdmsr' and 'wrmsr'?
> > 
> > That would allow at least in the case of Xen, to omit a whole bunch
> > of MSR writes/reads during the boot that are not neccessary as we would
> > not trap in the hypervisor - but could use the pvops version of
> > read/write MSR calls to just do a nop.
> > 
> 
> Why is this code invoked on Xen at all?  That seems crazy.

 [PATCH v4 09/11] x86/head64.c: Early update ucode in 64-bit

has this in x86_64_start_kernel:

..
        load_idt((const struct desc_ptr *)&idt_descr);

+       /*
+        * Load microcode early on BSP.
+        */
+       load_ucode_bsp(__va(real_mode_data));
+
        copy_bootdata(__va(real_mode_data));

Which gets called after xen_start_kernel has setup pagetables,
bootparams, etc ready for the generic code to be invoked.

Or am I looking at an old version of these patches.
> 
> 	-hpa
> 
> 
