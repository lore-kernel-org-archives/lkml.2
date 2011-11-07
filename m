Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1KGNcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:32:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43269 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1KGNcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:32:23 -0500
Date: Mon, 7 Nov 2011 21:31:31 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
Message-ID: <20111107133131.GB2783@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
 <1320669279.18053.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1320669279.18053.29.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 01:34:39PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-11-04 at 17:26 +0800, Yong Zhang wrote:
> > Since commit f59de89 [lockdep: Clear whole lockdep_map on initialization],
> > lockdep_init_map() will clear all the struct. But it will break
> > lock_set_class()/lock_set_subclass(). A typical race condition
> > is like below:
> 
> This is a horridly ugly patch, why not simply revert that memset commit?

I prefer reverting that commit, but bugzilla is down and I don't know
what the real problem behind that commit.

> I really can't see the point of that, and keeping the name/key pointers
> around (which can only be over-written with the same values, right?)
> would also cure the problem.
> 
> Sadly the changelog is completely devoid of useful information (which is
> my own damn fault, I should never have accepted the patch in that form),
> so I can't actually comment on what it was supposed to fix.

me too :(
And going through lkml history, I find nothing about it.

> 
> Arguably kmemcheck is on crack or so since both name and key pointers
> should be in .data so there cannot be a leak by copying the thing over.

Maybe Tejun can give more detail on it.

Thanks,
Yong
