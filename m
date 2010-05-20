Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0ETSyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:54:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41102 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0ETSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:54:19 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
In-reply-to: <alpine.LFD.2.00.1005201043321.23538@i5.linux-foundation.org>
	(message from Linus Torvalds on Thu, 20 May 2010 10:49:46 -0700 (PDT))
Subject: Re: [RFC PATCH] fuse: support splice() reading from fuse device
References: <E1OF3kc-00084X-Hi@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005201043321.23538@i5.linux-foundation.org>
Message-Id: <E1OFAsd-0000Ra-1V@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 May 2010 20:54:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Linus Torvalds wrote:
> Are there actual real loads that get improved? I don't care if it means 
> that the improvement goes from three orders of magnitude to just a couple 
> of percent. The "couple of percent on actual loads" is a lot more 
> important than "many orders of magnitude on a made-up benchmark".

The reason I've been looking at zero copy for fuse is that embedded
people have been complaining about fuse's large CPU overhead for I/O.
So large in fact that it was having a performance impact even for
relatively slow devices.  And most of that overhead comes from copying
data around.

So it's not the 20GB/s throughput that's interesting but the reduced
CPU overhead, especially on slower processors.  Apart from cache
effects 20GB/s throughput with a null filesystem means 1% CPU at
200MB/s transfer speed with _any_ filesystem.  Without bigger requests
that translates to 4% overhead and without zero copy about 15%.
That's on a core2/1.8GHz, with an embedded CPU the overhead reduction
would be even more significant.

Miklos
