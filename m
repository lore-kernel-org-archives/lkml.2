Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0ETMwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:52:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33380 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab0ETMwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:52:22 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
From: Andi Kleen <andi@firstfloor.org>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu>
Date: Thu, 20 May 2010 14:52:15 +0200
In-Reply-To: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> (Miklos Szeredi's message of "Wed\, 19 May 2010 18\:45\:55 +0200")
Message-ID: <87k4qywxa8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:
> +
> +	/*
> +	 * We can shrink the pipe, if arg >= pipe->nrbufs. Since we don't
> +	 * expect a lot of shrink+grow operations, just free and allocate
> +	 * again like we would do for growing. If the pipe currently
> +	 * contains more buffers than arg, then return busy.
> +	 */
> +	if (arg < pipe->nrbufs)
> +		return -EBUSY;
> +
> +	bufs = kcalloc(arg, sizeof(struct pipe_buffer), GFP_KERNEL);

While this is conceptually like socket buffers, socket buffers
have sophisticated mechanisms to throttle their memory use
under low memory conditions. That's not there here?

It means every user could pin a lot of memory.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
