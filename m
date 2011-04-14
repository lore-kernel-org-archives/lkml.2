Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab1DNJgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:36:15 -0400
Received: from 8bytes.org ([88.198.83.132]:36547 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab1DNJgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:36:14 -0400
Date: Thu, 14 Apr 2011 11:36:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110414093612.GE18463@8bytes.org>
References: <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110414040337.GC12781@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110414040337.GC12781@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 01:03:37PM +0900, Tejun Heo wrote:
> Hello,
> 
> On Wed, Apr 13, 2011 at 07:33:40PM -0700, Linus Torvalds wrote:
> > On Wednesday, April 13, 2011, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > On Wednesday, April 13, 2011, H. Peter Anvin <hpa@zytor.com> wrote:
> > >>
> > >> Yes.  However, even if we *do* revert (and the time is running short on
> > >> not reverting) I would like to understand this particular one, simply
> > >> because I think it may very well be a problem that is manifesting itself
> > >> in other ways on other systems.
> > 
> >  sorry, fingerfart. Anyway, I agree 100%.
> > 
> >  we definitely want to also understand the reason for things not
> > working, even if we do revert..
> 
> There were (and still are) places where memblock callers implemented
> ad-hoc top-down allocation by stepping down start limit until
> allocation succeeds.  Several of them have been removed since top-down
> became the default behavior, so simply reverting the commit is likely
> to cause subtle issues.  Maybe the best approach is introducing
> @topdown parameter and use it selectively for pure memory allocations.

Wouldn't it be better to provide a seperate memblock allocation
function which operates top-down and use this one in the places that
need it? This way it wouldn't break code that relies on bottom-up.

	Joerg

