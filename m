Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0ESQxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:53:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883Ab0ESQxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:53:01 -0400
Date: Wed, 19 May 2010 09:49:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, akpm@linux-foundation.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
In-Reply-To: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 May 2010, Miklos Szeredi wrote:
> 
> One issue I see is that it's possible to grow pipes indefinitely.
> Should this be restricted to privileged users?

Yes. But perhaps only if it grows past the default (or perhaps "default*2" 
or similar). That way a normal user could shrink the pipe buffers, and 
then grow them again if he wants to.

Oh, and I think you need to also require that there be at least two 
buffers. Otherwise we can't guarantee POSIX behavior, I think.

		Linus
