Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0GBUsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 16:48:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40750 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0GBUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 16:48:19 -0400
Date: Fri, 2 Jul 2010 14:48:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Break out types from <linux/list.h> to
	<linux/list_types.h>.
Message-ID: <20100702204817.GB5842@parisc-linux.org>
References: <201007021811.04197.arnd@arndb.de> <201007021747.o62HlgmV019405@farm-0002.internal.tilera.com> <20100702191910.GA5842@parisc-linux.org> <4C2E3F1F.3010202@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2E3F1F.3010202@tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 03:33:52PM -0400, Chris Metcalf wrote:
> On 7/2/2010 3:19 PM, Matthew Wilcox wrote:
> > Why a new header file instead of linux/types.h?
> 
> I was working from analogy to kvm_types.h, mm_types.h, rwlock_types.h,
> spinlock_types.h.  My impression is that linux/types.h is generally for
> basic (non-struct) types, with atomic_t/atomic64_t being added as
> "almost non-struct types", and of course the historical exception of
> "struct ustat", which has been there since the dawn of time (0.97 anyway).

I think list_head, hlist_head and hlist_node qualify as "almost non-struct
types", don't you?  :-)

I wouldn't mind seeing kvm_types.h, rwlock_types.h and spinlock_types.h
merged into types.h, personally.  They're all pretty fundamental kernel
kind of types.  It's a matter of taste, and I'm not particularly fussed
one way or the other.

mm_types.h is complex and full of mm-specific information, so keeping
it separate makes sense to me.

I just object to the unnecessary creation of tiny files like this.
Which is how we ended up with atomic_t and atomic64_t in there in the
first place :-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
