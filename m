Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab2KUHwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:52:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2KUHwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:52:30 -0500
Date: Tue, 20 Nov 2012 23:52:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Thelen <gthelen@google.com>
Cc: glommer@parallels.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: kmem accounting netperf data
Message-Id: <20121120235224.f4e9e1c6.akpm@linux-foundation.org>
In-Reply-To: <xr937gplwkcn.fsf@gthelen.mtv.corp.google.com>
References: <xr937gplwkcn.fsf@gthelen.mtv.corp.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012 09:03:52 -0800 Greg Thelen <gthelen@google.com> wrote:

> We ran some netperf comparisons measuring the overhead of enabling
> CONFIG_MEMCG_KMEM with a kmem limit.  Short answer: no regression seen.
> 
> This is a multiple machine (client,server) netperf test.  Both client
> and server machines were running the same kernel with the same
> configuration.
> 
> A baseline run (with CONFIG_MEMCG_KMEM unset) was compared with a full
> featured run (CONFIG_MEMCG_KMEM=y and a kmem limit large enough not to
> put additional pressure on the workload).  We saw no noticeable
> regression running:
> - TCP_CRR efficiency, latency
> - TCP_RR latency, rate
> - TCP_STREAM efficiency, throughput
> - UDP_RR efficiency, latency
> The tests were run with a varying number of concurrent connections
> (between 1 and 200).
> 
> The source came from one of Glauber's branches
> (git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg
> kmemcg-slab):
>   commit 70506dcf756aaafd92f4a34752d6b8d8ff4ed360
>   Author: Glauber Costa <glommer@parallels.com>
>   Date:   Thu Aug 16 17:16:21 2012 +0400
> 
>       Add slab-specific documentation about the kmem controller
> 
> It's not the latest source, but I figured the data might still be
> useful.

Let's cc the netdev guys, who will be pleased to hear that we didn't
break their stuff for once ;)

Thanks for testing - it was a concern.
