Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0ETTWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:22:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054Ab0ETTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:22:17 -0400
Date: Thu, 20 May 2010 12:19:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [RFC PATCH] fuse: support splice() reading from fuse device
In-Reply-To: <E1OFAsd-0000Ra-1V@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.2.00.1005201215120.23538@i5.linux-foundation.org>
References: <E1OF3kc-00084X-Hi@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005201043321.23538@i5.linux-foundation.org> <E1OFAsd-0000Ra-1V@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 May 2010, Miklos Szeredi wrote:
> 
> So it's not the 20GB/s throughput that's interesting but the reduced
> CPU overhead, especially on slower processors.  Apart from cache
> effects 20GB/s throughput with a null filesystem means 1% CPU at
> 200MB/s transfer speed with _any_ filesystem.

No it doesn't. Really.

It means 1% CPU at 200MB _IF_ you trigger the zero copy and nothing else!

But that's a damn big if. Does it ever trigger in practice? I doubt it. In 
practice, you'll have to fill the pages with something in the first place. 
In practice, the destination of the data is such that you'll often end up 
copying anyway - it won't be /dev/null.

That's why I claim your benchmark is meaningless. It does NOT even say 
what you claim it says. It does not say 1% CPU on a 200MB/s transfer, 
exactly the same way my stupid pipe zero-copy didn't mean that people 
could magically get MB/s throughput with 1% CPU on pipes.

It says nothing at all, in short. You need to have a real source, and a 
real destination. Not some empty filesystem and /dev/null destination.

			Linus
