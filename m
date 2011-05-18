Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab1ERRVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:21:18 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:42654 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933132Ab1ERRVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:21:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: wWE8oIYVM1n43XBS1Rctq2slvj73.pl0mIf7qwZfaBxUauN
 mU8tU6SSN13LGZvcSm9.yhSis40p.kxCv1KSYBzzlRxMsVLAkroVnc8HO6Kl
 8IeQW9sV18kz7saxB5CHAupcqbEMLWIoS3J_vfyFlH.UMMyMzo2epa3Zwhxy
 Hy1NTrgRCDzdQ93BKxJ8Ja9ln1v9Zg_qhCB8A8iUap9kS2.sffilnd7DliB5
 GxR3yafdoVvC9bDWWGIncCsJJVeeJKKX7qp7r51tRjWBwfVgkM5xW9_E4S24
 teket8xERCOpBn2SQiCJxE7uJmzHSxAvMNakQz6Qu8JTg8cIoeJWqsd9TVPw
 Mapx6IgyoRx2w3YudXuNe2_PcGQ--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 18 May 2011 12:21:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm: slub: Do not wake kswapd for SLUBs speculative
 high-order allocations
In-Reply-To: <4DD36299.8000108@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1105181218520.12423@router.home>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de> <1305295404-12129-3-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105161410090.4353@chino.kir.corp.google.com> <4DD36299.8000108@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011, Pekka Enberg wrote:

> On 5/17/11 12:10 AM, David Rientjes wrote:
> > On Fri, 13 May 2011, Mel Gorman wrote:
> >
> > > To avoid locking and per-cpu overhead, SLUB optimisically uses
> > > high-order allocations and falls back to lower allocations if they
> > > fail.  However, by simply trying to allocate, kswapd is woken up to
> > > start reclaiming at that order. On a desktop system, two users report
> > > that the system is getting locked up with kswapd using large amounts
> > > of CPU.  Using SLAB instead of SLUB made this problem go away.
> > >
> > > This patch prevents kswapd being woken up for high-order allocations.
> > > Testing indicated that with this patch applied, the system was much
> > > harder to hang and even when it did, it eventually recovered.
> > >
> > > Signed-off-by: Mel Gorman<mgorman@suse.de>
> > Acked-by: David Rientjes<rientjes@google.com>
>
> Christoph? I think this patch is sane although the original rationale was to
> workaround kswapd problems.

I am mostly fine with it. The concerns that I have is if there is a
large series of high order allocs then at some point you would want
kswapd to be triggered instead of high order allocs constantly failing.

Can we have a "trigger once in a while" functionality?

