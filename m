Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0JGQD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:03:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32885 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0JGQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:03:55 -0400
Date: Thu, 7 Oct 2010 18:03:41 +0200
From: Gleb Natapov <gleb@minantech.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org
Subject: Re: [PATCH v6 04/12] Add memory slot versioning and use it to
 provide fast guest write interface
Message-ID: <20101007160340.GD4120@minantech.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-5-git-send-email-gleb@redhat.com>
 <20101005165738.GA32750@amt.cnet>
 <20101006111417.GX11145@redhat.com>
 <20101006143847.GB31423@amt.cnet>
 <20101006200836.GC4120@minantech.com>
 <4CAD9A2D.7020009@redhat.com>
 <20101007154248.GA30949@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007154248.GA30949@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 12:42:48PM -0300, Marcelo Tosatti wrote:
> On Thu, Oct 07, 2010 at 12:00:13PM +0200, Avi Kivity wrote:
> >  On 10/06/2010 10:08 PM, Gleb Natapov wrote:
> > >>  Malicious userspace can cause entry to be cached, ioctl
> > >>  SET_USER_MEMORY_REGION 2^32 times, generation number will match,
> > >>  mark_page_dirty_in_slot will be called with pointer to freed memory.
> > >>
> > >Hmm. To zap all cached entires on overflow we need to track them. If we
> > >will track then we can zap them on each slot update and drop "generation"
> > >entirely.
> > 
> > To track them you need locking.
> > 
> > Isn't SET_USER_MEMORY_REGION so slow that calling it 2^32 times
> > isn't really feasible?
> 
> Assuming it takes 1ms, it would take 49 days.
> 
We may fail ioctl when max value is reached. The question is how much slot
changes can we expect from real guest during its lifetime.

> > In any case, can use u64 generation count.
> 
> Agree.
Yes, 64 bit ought to be enough for anybody.

--
			Gleb.
