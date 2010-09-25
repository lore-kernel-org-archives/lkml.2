Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab0IYTZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 15:25:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53524 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab0IYTZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 15:25:12 -0400
Date: Sat, 25 Sep 2010 20:25:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rth@twiddle.net, linux-kernel@vger.kernel.org
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
Message-ID: <20100925192509.GX19804@ZenIV.linux.org.uk>
References: <20100925181304.GV19804@ZenIV.linux.org.uk>
 <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
 <20100925191836.GW19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100925191836.GW19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 08:18:36PM +0100, Al Viro wrote:
> Agreed.  There are only two places that need change (return to kernel path
> in ret_from_syscall and kernel_thread essentially jumping to the same path),
> so I'll just add
> ret_to_kernel:
>         lda     $16, 7
>         call_pal PAL_swpipl
> 	br	restore_all
> and make these two places go to ret_to_kernel instead of restore_all.

BTW, am I right assuming that HAE modifications is UP-only thing?  It would
be obviously b0rken on any SMP box, since alpha_mv is not per-CPU thing...
