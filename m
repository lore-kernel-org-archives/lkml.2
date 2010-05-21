Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0EUBza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:55:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:33673 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab0EUBz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:55:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SmiLNDldbnJ5DY3U1AEeCknp4AWgKSz3D8XZs0YPwSBsyoc6BXjdeUtp+BGENbr2F
	Q/EEbSuyTcYInIrHNrYxg==
Date: Thu, 20 May 2010 18:55:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: tim <tim.c.chen@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] tmpfs: Improve tmpfs scalability
In-Reply-To: <1274225666.31973.8949.camel@mudge.jf.intel.com>
Message-ID: <alpine.DEB.1.00.1005201837040.21050@tigran.mtv.corp.google.com>
References: <1274225666.31973.8949.camel@mudge.jf.intel.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, tim wrote:
> 
> We created a token jar library implementing
> per cpu cache of tokens to avoid lock contentions whenever
> we retrieve or return a token to a token jar.  Using this library
> with tmpfs, we find Aim7 fserver throughput improved 270% 
> on a 4 socket, 32 cores NHM-EX system.
> 
> In current implementation of tmpfs, whenever we
> get a new page, stat_lock in shmem_sb_info needs to be acquired.  
> This causes a lot of lock contentions when multiple
> threads are using tmpfs simultaneously, which makes
> system with large number of cpus scale poorly.
> Almost 75% of cpu time was spent contending on
> stat_lock when we ran Aim7 fserver load with 128 threads
> on a 4 socket, 32 cores NHM-EX system.
> 
> The first patch in the series implements the quick token jar. 
> The second patch update the shmem code of tmpfs to use this
> library to improve tmpfs performance.

Interesting, thank you - I'll take a look, but not this week.

I do hope you're using Aim7 just as an example: you know that mounting
tmpfs with nr_blocks=0,nr_inodes=0 skips those shmem_sb_info updates
altogether?  Mounting in such a way should be fine for getting better
numbers out of Aim7; but yes, there are reallife uses for tmpfs which
are safer with the nr_blocks,nr_inodes limits.

Hugh
