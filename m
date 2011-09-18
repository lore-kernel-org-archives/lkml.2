Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1IRJgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 05:36:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53680 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1IRJgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 05:36:04 -0400
Date: Sun, 18 Sep 2011 11:35:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Brian Gerst <brgerst@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Arkaprava Basu <arkaprava.basu@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: TLB flush question (x86_64)
Message-ID: <20110918093559.GB28953@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Brian Gerst <brgerst@gmail.com>, Andreas Mohr <andi@lisas.de>,
	Arkaprava Basu <arkaprava.basu@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAErB21iHz_ToVzfU8aPkY8OW5iMOTPgPMdQBsmxo=5YUCMb6Aw@mail.gmail.com>
 <20110917191221.GA24295@rhlx01.hs-esslingen.de>
 <CAMzpN2gNtnRVPreeeUVOCr7_t5j6xx+YGHeJkAgqTS2PyUibbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMzpN2gNtnRVPreeeUVOCr7_t5j6xx+YGHeJkAgqTS2PyUibbw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 07:37:59PM -0400, Brian Gerst wrote:
> On Sat, Sep 17, 2011 at 3:12 PM, Andreas Mohr <andi@lisas.de> wrote:
> > Hi,
> >
> > decided to reply since there hasn't been any activity yet.
> >
> >> Is there any particular reason why
> >> the entire address space is flushed from the tlb while only a range of
> >> virtual address space was supposedly required to be flushed?
> >
> > While this particular function has actually changed in less medieval
> > kernel versions, it would be nice if someone knew an answer to that,
> > especially since TLB activity may have grave performance implications.
> >
> 
> x86 hardware can only flush single pages or the whole TLB.  It would
> be possible to loop over a small set of pages and invalidate each one,
> but the threshold for where that becomes more efficient than flushing
> everything is difficult to determine.

... also, TLBs in current CPUs are highly optimized beasts so that the
cost of a full rewalk is paid only very seldomly by caching even partial
translations in lower level TLBs (L2), etc.

And also, flush_tlb_mm ends up modifying CR3 which doesn't flush the
global mappings.

-- 
Regards/Gruss,
    Boris.
