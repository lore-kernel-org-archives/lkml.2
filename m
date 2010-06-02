Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0FBFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab0FBFQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:16:25 -0400
Date: Wed, 2 Jun 2010 01:15:43 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andi Kleen <ak@linux.intel.com>
cc: device-mapper development <dm-devel@redhat.com>,
       herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
       agk@redhat.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
In-Reply-To: <4C04AB6E.1080305@linux.intel.com>
Message-ID: <Pine.LNX.4.64.1006020110220.22695@hs20-bc2-1.build.redhat.com>
References: <20100531160425.GA20344@basil.fritz.box>
 <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
 <4C04AB6E.1080305@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Andi Kleen wrote:

> , Mikulas Patocka wrote:
> > Questions:
> > 
> > If you are optimizing it,
> > 
> > 1) why don't you optimize it in such a way that if one CPU submits
> > requests, the crypto work is spread among all the CPUs? Currently it
> > spreads the work only if different CPUs submit it.
> 
> This case is only useful with very slow CPUs and is handled by pcrypt
> in theory
> 
> (but I haven't tested it)

Almost every CPU is "very slow" so that it lags behind disk when 
encrypting. CPUs with hardware AES may be the exception.

> > 2) why not optimize software async crypto daemon (crypt/cryptd.c) instead
> > of dm-crypt, so that all kernel subsystems can actually take advantage of
> > those multi-CPU optimizations, not just dm-crypt?
> 
> Normally most subsystems are multi-CPU already, unless they limit
> themselves artitifically like dm-crypt.
> 
> For dm-crypt would be wasteful to funnel everything through two single CPU
> threads just
> to spread it out again.  That is why I also used per CPU IO threads too.

If one CPU submits I/O for 10MB of data, your patch makes no 
paralelization at all. Because all those 10MB will be encrypted by the 
same CPU that submitted it.

> -Andi

Mikulas
