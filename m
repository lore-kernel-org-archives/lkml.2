Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0FACk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 22:40:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab0FACkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 22:40:24 -0400
Date: Mon, 31 May 2010 22:39:37 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: device-mapper development <dm-devel@redhat.com>
cc: Milan Broz <mbroz@redhat.com>, ak@linux.intel.com,
       linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
       Andi Kleen <andi@firstfloor.org>, agk@redhat.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
In-Reply-To: <20100531182724.GG10766@basil.fritz.box>
Message-ID: <Pine.LNX.4.64.1005312236570.6372@hs20-bc2-1.build.redhat.com>
References: <20100531160425.GA20344@basil.fritz.box> <4C03F04D.4040200@redhat.com>
 <20100531174225.GE10766@basil.fritz.box> <4C03FB8E.1060109@redhat.com>
 <20100531182724.GG10766@basil.fritz.box>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> 2) Per volume threads and mempools were added to solve low memory
> > >> problems (exhausted mempools), isn't now possible deadlock here again?
> > > 
> > > Increasing the number of parallel submitters does not increase deadlocks
> > > with mempool as long as they don't nest.  They would just
> > > block each other, but eventually make progress as one finishes. 
> > 
> > I mean if they nest of course, sorry for confusion.
> 
> No change to that, it's the same as it always worked.
> 
> Anyways, Right now you would need to nest more than 16 times I think
> to exhaust the mempool (or 8, but the pages are less critical I think)
> 
> For me that seems like a "don't do that if hurts" situation.

If the mempools are per-instance (they are), it can nest any number of 
times, because each nested instance will get new mempools. It is not a 
problem.

Mikulas
