Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2DPS1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:27:38 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46531 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2DPS1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:27:37 -0400
Date: Mon, 16 Apr 2012 14:27:28 -0400 (EDT)
Message-Id: <20120416.142728.864894452301706752.davem@davemloft.net>
To: mingo@kernel.org
Cc: joe@perches.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, apw@canonical.com
Subject: Re: Please fix or revert: [PATCH] checkpatch: add --strict tests
 for braces, comments and casts
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120416091719.GA4113@gmail.com>
References: <20120416091719.GA4113@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 16 Apr 2012 11:27:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>
Date: Mon, 16 Apr 2012 11:17:20 +0200

> 
> This recent checkpatch commit, added in v3.4-rc1:
> 
>   aad4f6149831 checkpatch: add --strict tests for braces, comments and casts
> 
> made the default checkpatch run complain about the following 
> perfectly fine multi-line comment block:
> 
> +               rdp->qlen_lazy = 0;
> +               rdp->qlen = 0;
> +
> +               /*
> +                * Adopt all callbacks.  The outgoing CPU was in no shape
> +                * to advance them, so make them all go through a full
> +                * grace period.
> +                */
> +               *receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
> 

I would like to formally propose that we change CodingStyle so that
our comments are of the form:

	/* XXX
	 * YYY
	 */

So that we can save one line of vertical space.

We've adopted this all across the networking, and the code looks a
lot nicer as well as allowing more actual code onto a single window
of text.
