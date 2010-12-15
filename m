Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab0LOFzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 00:55:19 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32195 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab0LOFzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 00:55:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHvnB015Lc+z/2dsb2JhbACkG3nBL4VKBJED
Date: Wed, 15 Dec 2010 16:54:50 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Nick Piggin <npiggin@gmail.com>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
Message-ID: <20101215055450.GC3398@amd>
References: <20101209070938.GA3949@amd>
 <19324.1291990997@jrobl>
 <20101213014553.GA6522@amd>
 <9580.1292225351@jrobl>
 <AANLkTimeWSEUU6EYa4yWY11OyAVQqNu5eoBZc5ddqHQL@mail.gmail.com>
 <20101215043840.GA7692@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101215043840.GA7692@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 12:38:40PM +0800, Américo Wang wrote:
> On Mon, Dec 13, 2010 at 07:25:05PM +1100, Nick Piggin wrote:
> >On Mon, Dec 13, 2010 at 6:29 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
> >> But is the "rep cmp has quite a long latency" issue generic for all x86
> >> architecture, or Westmere system specific?
> >
> >I don't believe it is Westmere specific. Intel and AMD have
> >been improving these instructions in the past few years, so
> >Westmere is probably as good or better than any.
> >
> >That said, rep cmp may not be as heavily optimized as the
> >set and copy string instructions.
> >
> >In short, I think the change should be suitable for all x86 CPUs,
> >but I would like to hear more opinions or see numbers for other
> >cores.
> >
> 
> How about other arch? If this is only for x86, shouldn't it be
> protected by CONFIG_X86?

That's what I would like to know, but I suspect that for very short
strings we are dealing with, the custom loop will be fine for
everybody.

