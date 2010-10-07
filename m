Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab0JGIuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 04:50:14 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51027 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0JGIuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 04:50:13 -0400
Date: Thu, 7 Oct 2010 17:48:37 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/4] HWPOISON: Report correct address granuality for AO
 huge page errors
Message-ID: <20101007084837.GG9891@spritzera.linux.bs1.fc.nec.co.jp>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
 <1286398141-13749-4-git-send-email-andi@firstfloor.org>
 <20101007003120.GB9891@spritzera.linux.bs1.fc.nec.co.jp>
 <20101007073848.GG5010@basil.fritz.box>
 <20101007084101.GE9891@spritzera.linux.bs1.fc.nec.co.jp>
 <20101007084529.GH5010@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20101007084529.GH5010@basil.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 10:45:29AM +0200, Andi Kleen wrote:
> On Thu, Oct 07, 2010 at 05:41:01PM +0900, Naoya Horiguchi wrote:
> > On Thu, Oct 07, 2010 at 09:38:48AM +0200, Andi Kleen wrote:
> > > On Thu, Oct 07, 2010 at 09:31:20AM +0900, Naoya Horiguchi wrote:
> > > > > @@ -198,7 +199,8 @@ static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
> > > > >  #ifdef __ARCH_SI_TRAPNO
> > > > >  	si.si_trapno = trapno;
> > > > >  #endif
> > > > > -	si.si_addr_lsb = PAGE_SHIFT;
> > > > > +	order = PageCompound(page) ? huge_page_order(page) : PAGE_SHIFT;
> > > >                                                      ^^^^
> > > >                                      huge_page_order(page_hstate(page)) ?
> > > 
> > > Ok.
> > 
> > order seems to represent a least significant bit of corrupted address,
> > so is huge_page_order() + PAGE_SHIFT or huge_page_shift() correct?
> 
> Both I guess.
> 
> > And since @page can be a tail page, compound_head() is needed as Wu-san pointed out.
> > So huge_page_shift(page_hstate(compound_head(page))) looks good for me.
> 
> I used compound_order(compound_head(page)) + PAGE_SHIFT now.
> This even works for non compound, so the special case check
> can be dropped.

OK.

Thanks,
Naoya Horiguchi
