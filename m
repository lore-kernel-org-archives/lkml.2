Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554Ab0DHH0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:26:00 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34062 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509Ab0DHHZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n8NROewiopq0szTwZHJ8+EpNNL4vzV7cPaMARE+4uIdK2oxUheuSIdc4v6Kv3Iut52
         w4GK8eGeuFiGopz4RN2Ntg7rh6q57nj68GoUshlMNA6hMa5dIbL6ciRT7DfAiVDQFwQK
         P/GKTIHAVyKfrF/KdBPT73rrbLZA17uOtBQpw=
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: yanmin_zhang@linux.intel.com, cl@linux-foundation.org,
       penberg@cs.helsinki.fi, netdev@vger.kernel.org, tj@kernel.org,
       alex.shi@intel.com, linux-kernel@vger.kernel.org, ling.ma@intel.com,
       tim.c.chen@intel.com, akpm@linux-foundation.org
In-Reply-To: <20100408.000557.180546976.davem@davemloft.net>
References: <1270702774.8141.49.camel@edumazet-laptop>
	 <1270705153.8141.58.camel@edumazet-laptop>
	 <1270710019.2215.4.camel@edumazet-laptop>
	 <20100408.000557.180546976.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 09:25:51 +0200
Message-ID: <1270711551.2215.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 08 avril 2010 à 00:05 -0700, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Thu, 08 Apr 2010 09:00:19 +0200
> 
> > If run individually, the tests results are more what we would expect
> > (slow), but if machine runs the two set of process concurrently, each
> > group runs much faster...
> 
> BTW, I just discovered (thanks to the function graph tracer, woo hoo!)
> that loopback TCP packets get fully checksum validated on receive.
> 
> I'm trying to figure out why skb->ip_summed ends up being
> CHECKSUM_NONE in tcp_v4_rcv() even though it gets set to
> CHECKSUM_PARTIAL in tcp_sendmsg().
> 
> I wonder how much this accounts for some of the hackbench
> oddities... and other regressions in loopback tests we've seen.
> :-)
> 
> Just FYI...

Thanks !

But hackbench is a af_unix benchmark, so loopback stuff is not used that
much :)


