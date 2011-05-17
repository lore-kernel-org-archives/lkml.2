Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab1EQRwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:52:23 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:28865 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756041Ab1EQRwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:52:19 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: pLmYH24VM1nJss40U5eXItTNnGHQ2AcglZnTLVAIeWxo_Hi
 ssMgfQhjGAZDnterWtoQHhQNkNuljLavMrHmk1J.w8uDOV6Q1Sk9ipBi6Qm1
 uK7tIt_6Nw8fw_2S5DcuNvcGRX4fzJxLR1TRV37WKkJHbgix8256gBRkR8vp
 vgCvyU.UbzgRv4nuAYO8iFsAAO63_7o7Nh_cXV7qkzIq.sY3xn1HAbSQmJvC
 v1uj1q70DN13n44vv3MNPgKtQuhL5YcCDHEkfcTY3oY0la5H.adIXNVJxtMS
 a9PPU3er71iUYyoFjpfhBuwo1zaXrYn3UZn3esLix.6sXhyLebYxcr2OUugZ
 Jm3j0uBDqKd4158iJaeImW9zT
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 17 May 2011 12:52:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/4] mm: slub: Do not take expensive steps for SLUBs
 speculative high-order allocations
In-Reply-To: <20110517162256.GO5279@suse.de>
Message-ID: <alpine.DEB.2.00.1105171251450.15604@router.home>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de> <1305295404-12129-4-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105161411440.4353@chino.kir.corp.google.com> <20110517084227.GI5279@suse.de> <alpine.DEB.2.00.1105170847550.11187@router.home>
 <20110517162256.GO5279@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Mel Gorman wrote:

> > That is not what I meant. I would like more higher order allocations to
> > succeed. That does not mean that slubs allocation methods and flags passed
> > have to stay the same. You can change the slub behavior if it helps.
> >
>
> In this particular patch, the success rate for high order allocations
> would likely decrease in low memory conditions albeit the latency when
> calling the page allocator will be lower and the disruption to the
> system will be less (no copying or reclaim of pages). My expectation
> would be that it's cheaper for SLUB to fall back than compact memory
> or reclaim pages even if this means a slab page is smaller until more
> memory is free. However, if the "goodness" criteria is high order
> allocation success rate, the patch shouldn't be merged.

The criteria is certainly overall system performance and not a high order
allocation rate.
