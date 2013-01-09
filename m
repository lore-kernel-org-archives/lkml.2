Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab3AINgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:36:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30237 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab3AINgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:36:23 -0500
Date: Wed, 9 Jan 2013 08:35:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v5 00/12] x86/microcode: Early load microcode
Message-ID: <20130109133556.GA18690@phenom.dumpdata.com>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
 <20130103174455.GA7350@localhost.localdomain>
 <50E5C47B.6060707@zytor.com>
 <20130108194633.GA15194@phenom.dumpdata.com>
 <50EC77DB.6090300@zytor.com>
 <20130108200432.GE15194@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108200432.GE15194@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:04:33PM -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 08, 2013 at 11:47:39AM -0800, H. Peter Anvin wrote:
> > On 01/08/2013 11:46 AM, Konrad Rzeszutek Wilk wrote:
> > > 
> > > OK. I am trying to figure out whether this usage of native_* for the
> > > MSRs was done on purpose - and it sounds like the answer is no. If so -
> > > can it be done using the normal 'safe_rdmsr' and 'wrmsr'?
> > > 
> > > That would allow at least in the case of Xen, to omit a whole bunch
> > > of MSR writes/reads during the boot that are not neccessary as we would
> > > not trap in the hypervisor - but could use the pvops version of
> > > read/write MSR calls to just do a nop.
> > > 
> > 
> > Why is this code invoked on Xen at all?  That seems crazy.
> 
>  [PATCH v4 09/11] x86/head64.c: Early update ucode in 64-bit
> 
> has this in x86_64_start_kernel:
> 
> ..
>         load_idt((const struct desc_ptr *)&idt_descr);
> 
> +       /*
> +        * Load microcode early on BSP.
> +        */
> +       load_ucode_bsp(__va(real_mode_data));
> +
>         copy_bootdata(__va(real_mode_data));
> 
> Which gets called after xen_start_kernel has setup pagetables,
> bootparams, etc ready for the generic code to be invoked.

And I am looking at the wrong code. The "x86_64_start_kernel" is
absolutly fine. It is "x86_64_start_reservations" that is invoked by Xen.

I got thrown off by the "copy_bootdata(.." which on v3.7 is in
"x86_64_start_reservations".

Duh!
> 
> Or am I looking at an old version of these patches.
> > 
> > 	-hpa
> > 
> > 
