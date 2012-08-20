Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2HTJdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:33:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40724 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab2HTJbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:31:05 -0400
Subject: Re: regression with poll(2)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Sage Weil <sage@inktank.com>, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        neilb@suse.de, a.p.zijlstra@chello.nl, michaelc@cs.wisc.edu,
        emunson@mgebm.net, sebastian@breakpoint.cc, cl@linux.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <20120820090443.GA3275@suse.de>
References: <alpine.DEB.2.00.1208151226250.15721@cobra.newdream.net>
	 <alpine.DEB.2.00.1208191051150.15570@cobra.newdream.net>
	 <20120820090443.GA3275@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Aug 2012 11:30:59 +0200
Message-ID: <1345455059.5158.302.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 10:04 +0100, Mel Gorman wrote:

> Can the following patch be tested please? It is reported to fix an fio
> regression that may be similar to what you are experiencing but has not
> been picked up yet.
> 
> -

This seems to help here.

Boot your machine with "mem=768M" or a bit less depending on your setup,
and try a netperf.

-> before patch :

# netperf
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
localhost.localdomain () port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    14.00       6.05   

-> after patch :

Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.00    18509.73   


