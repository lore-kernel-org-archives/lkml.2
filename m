Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab1LRBSg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 20:18:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42337 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1LRBSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 20:18:34 -0500
Date: Sun, 18 Dec 2011 04:18:28 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Put braces around potentially empty 'if' body in
 handle_pte_fault()
Message-ID: <20111218011828.GA4445@p183.telecom.by>
References: <alpine.LNX.2.00.1112180059080.21784@swampdragon.chaosbits.net>
 <1324167535.3323.63.camel@edumazet-laptop>
 <20111218003419.GE2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111218003419.GE2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 12:34:19AM +0000, Al Viro wrote:
> On Sun, Dec 18, 2011 at 01:18:55AM +0100, Eric Dumazet wrote:
> > Thats should be fixed in the reverse way :
> > 
> > #define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
> 
> There's a better way to do that -
> #define f(a) do { } while(0)
> does not work as a function returning void -
> 	f(1), g();
> won't work.  OTOH
> #define f(a) ((void)0)
> works just fine.

Two words: static inline.
