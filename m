Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab2BNQVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:21:41 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53765 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751544Ab2BNQVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:21:37 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX18dpnUJesgdkmZH7KrhfzztXMZN+yUZwwhdeUrIju
	Orb9et9q/pYWuU
From: Marc Dietrich <marvin24@gmx.de>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: fix powerpc linux-next break on zsmalloc
Date: Tue, 14 Feb 2012 17:21:05 +0100
Message-ID: <5736714.Unq6oKkpjO@ax5200p>
User-Agent: KMail/4.7.3 (Linux/3.2.0-14-generic; KDE/4.7.4; x86_64; ; )
In-Reply-To: <4F3A7121.9010803@linux.vnet.ibm.com>
References: <1329144469-8575-1-git-send-email-sjenning@linux.vnet.ibm.com> <4F3A480C.9090407@gmx.de> <4F3A7121.9010803@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Tuesday 14 February 2012 08:35:13 Seth Jennings wrote:
> On 02/14/2012 05:39 AM, Marc Dietrich wrote:
> > Am 14.02.2012 12:22, schrieb Marc Dietrich:
> >> Am 13.02.2012 15:47, schrieb Seth Jennings:
> >>> linux/vmalloc.h added to zsmalloc-main.c to resolve implicit
> >>> declaration errors.
> >>> 
> >>> X86 dependency added to zsmalloc and dependent drivers zcache and
> >>> zram.
> >>> 
> >>> This X86 only requirement is not ideal.  Working to find portable
> >>> functions for __flush_tlb_one and set_pte.
> >> 
> >> sorry, zcache/zram works fine one ARM here. Why not depend on
> >> !POWERPC?
> > 
> > ups, sorry again, I tested an older version only. flush_tlb_one and
> > set_pte is only used with the new allocator as it seems.
> 
> It would seem that the cpu-local tlb page flushing function for ARM
> is local_flush_tlb_kernel_page(), by look at the kmap_atomic() code
> in arch/arm/mm/highmem.c.
> 
> So each arch is using a slightly different approach here.
> 
> A simple #define per-arch could make a it a common call.  I think
> I'm going to code it up and see how it goes.

... and I'm happy to test it ;-)

Thanks

Marc

