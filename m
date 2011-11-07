Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab1KGNy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:54:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45985 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab1KGNy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:54:57 -0500
Date: Mon, 7 Nov 2011 14:54:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
Message-ID: <20111107135452.GA2975@gere.osrc.amd.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
 <1320669279.18053.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320669279.18053.29.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> I really can't see the point of that, and keeping the name/key pointers
> around (which can only be over-written with the same values, right?)
> would also cure the problem.

FWIW,

I ran the box with the memset commit reverted for a couple of days
before applying Young's patches and it didn't show any signs of
problems.

-- 
Regards/Gruss,
Boris.
