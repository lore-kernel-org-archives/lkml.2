Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0EFGUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:20:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53133 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab0EFGUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:20:19 -0400
Date: Thu, 6 May 2010 08:19:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 1/4] [tip:x86/mm] Correcting improper large page
 preservation
Message-ID: <20100506061930.GB1172@elte.hu>
References: <v2o817ecb6f1003311859nb14bab83y80f743a0accc5028@mail.gmail.com>
 <1270277000.2686.20.camel@sbs-t61>
 <g2g817ecb6f1004060751s1fd3d42bqc19b5c36b33c3c13@mail.gmail.com>
 <g2s817ecb6f1005051114kfbf4f33dwf473e0a30e00d614@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g2s817ecb6f1005051114kfbf4f33dwf473e0a30e00d614@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> On Tue, Apr 6, 2010 at 10:51 AM, Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
> > On Sat, Apr 3, 2010 at 2:43 AM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> >> On Wed, 2010-03-31 at 18:59 -0700, Siarhei Liakh wrote:
> >>> + ? ? /*
> >>> + ? ? ?* .data and .bss should always be writable.
> >>> + ? ? ?*/
> >>> + ? ? if ((within(pfn, __pa((unsigned long)_sdata) >> PAGE_SHIFT,
> >>> + ? ? ? ? ? ? ? ?__pa((unsigned long)_edata) >> PAGE_SHIFT)) ||
> >>> + ? ? ? ? (within(pfn, __pa((unsigned long)__bss_start) >> PAGE_SHIFT,
> >>> + ? ? ? ? ? ? ? ?__pa((unsigned long)__bss_stop) >> PAGE_SHIFT))) {
> >>> + ? ? ? ? ? ? pgprot_val(required) |= _PAGE_RW;
> >>> + ? ? }
> >>
> >> I have reviewed this patch and the only comment I have is:
> >>
> >> On 64bit kernels, kernel text/data mapping and kernel identity mappings
> >> are different virtual addresses mapping to same pfn ranges. For the
> >> data/bss pages, does it help (in identifying certain data corruptions
> >> more easily) in making the kernel identity mapping to be set to
> >> read-only and enforce the need of RW only for the kernel data mappings.
> >>
> >> Or is there some obscure code that uses something like
> >> __va(__pa(data_symbol)) and writes to it?
> >>
> >> If not, we can remove the __pa() constructs above and use the addr for
> >> comparisons.
> >
> > Done.
> > Patch V2 have been posted.
> 
> Does anyone have any feedback on the whole kernel RO/NX patch set? Or should 
> I re-post all 4 patches one more time?
> 
> Thank you.

Please do - i havent seen any other review feedback.

Thanks,

	Ingo
