Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1G2GFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:05:48 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60941 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520Ab1G2GFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:05:46 -0400
X-Sasl-enc: oiY+GEBejwaiAziIh3J0fHjzePE7F3cuTf6xCGEw/ACV 1311919545
Message-ID: <4E324DB4.7060600@fastmail.fm>
Date: Fri, 29 Jul 2011 16:05:40 +1000
From: Greg Banks <gnb@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: linux-nfs@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Fw: [PATCH] sunrpc: use better NUMA affinities
References: <20110729153207.17af3085@notabene.brown>
In-Reply-To: <20110729153207.17af3085@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/11 15:32, NeilBrown wrote:
>
> Hi Greg,
>   I saw this patch float past and thought of you... You may not be interested
>   any more, and it may be a perfectly good patch that does not need any
>   comment, but I thought I would let you know anyway.

Thanks Neil.

I've trimmed the cc list to limit the number of copies Trond and Bruce get:)

> From: Eric Dumazet<eric.dumazet@gmail.com>
> To: Trond Myklebust<Trond.Myklebust@netapp.com>
> Cc: "J. Bruce Fields"<bfields@fieldses.org>, Neil Brown<neilb@suse.de>,
> David Miller<davem@davemloft.net>, linux-nfs@vger.kernel.org, netdev
> <netdev@vger.kernel.org>, linux-kernel<linux-kernel@vger.kernel.org>
> Subject: [PATCH] sunrpc: use better NUMA affinities
>
>
> Use NUMA aware allocations to reduce latencies and increase throughput.


Briefly looking at the patch, it doesn't seem wrong but I'm surprised 
it's (still) necessary.

Some years ago at SGI we encountered that same problem; we solved it by 
delaying all the allocation of data structures associated with a thread 
so that they were performed in the thread itself, after the thread had 
been limited to run on a certain set of CPUs.  Thus the thread's normal 
allocation behaviour resulted in all of it's allocations being from 
node-local pages.  It was a pretty ugly patch, but it worked and made a 
huge difference to NFS throughput on large NUMA boxes.

Later Jeff Layton converted the sunrpc svc startup code to use kthreads 
and at the time I read his patches, pointed out this problem, and posted 
my patch for comparison

http://linux-nfs.org/pipermail/nfsv4/2008-May/008760.html

I seem to remember coming to the conclusion that Jeff eventually 
addressed this problem...am I misremembering or did something regress?

-- 
Greg.

