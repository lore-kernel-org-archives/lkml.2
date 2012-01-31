Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab2AaJ7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 04:59:15 -0500
Received: from ozlabs.org ([203.10.76.45]:53577 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab2AaJ7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 04:59:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
In-Reply-To: <20120130181639.GJ3355@google.com>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org> <20120130171558.GB3355@google.com> <alpine.DEB.2.00.1201301121330.28693@router.home> <20120130174256.GF3355@google.com> <alpine.DEB.2.00.1201301145570.28693@router.home> <20120130175434.GG3355@google.com> <alpine.DEB.2.00.1201301156530.28693@router.home> <20120130180224.GH3355@google.com> <alpine.DEB.2.00.1201301206080.28693@router.home> <20120130181639.GJ3355@google.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 31 Jan 2012 15:18:54 +1030
Message-ID: <87obtkjx3d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 10:16:39 -0800, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Jan 30, 2012 at 12:12:18PM -0600, Christoph Lameter wrote:
> > > I thought it didn't.  I rememer thinking about this and determining
> > > that NULL can't be allocated for dynamic addresses.  Maybe I'm
> > > imagining things.  Anyways, if it can return NULL for valid
> > > allocation, it is a bug and should be fixed.
> > 
> > I dont see anything that would hinder an arbitrary value to be returned.
> > NULL is also used for the failure case. Definitely a bug.
> 
> Given the address translation we do and kernel image layout, I don't
> think this can happen on x86.  It may theoretically possible on other
> archs tho.  Anyways, yeah, this one needs improving.

I tried setting the lower bit on all percpu ptrs, but since non-dynamic
percpu vars could have odd alignments, that fails in general.

> > > We don't have returned addr >= PAGE_SIZE guarantee yet but I'm fairly
> > > sure that's the only acceptable direction if we want any improvement
> > > in this area.
> > 
> > The ZERO_SIZE_PTR patch would not make the situation that much worse.
> 
> I'm not objecting to marking zero-sized allocations per-se.  I'm
> saying the patch is pointless at this point.  It doesn't contribute
> anything while giving the illusion of better error checking than we
> actually do.  Let's do it when it can actually work.

Disagree: This patch works.  It allows zero-size per-cpu allocs, like
the other allocators.  Nor does it fail in practice.

We should do better, but the perfect is the enemy of the good.

Cheers,
Rusty.
