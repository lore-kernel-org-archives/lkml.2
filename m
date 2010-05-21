Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab0EUBdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:33:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab0EUBdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:33:06 -0400
Date: Fri, 21 May 2010 11:33:00 +1000
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] ipc: use shifts to extract seq/idx
Message-ID: <20100521013300.GJ2516@laptop>
References: <20100520065911.GG2516@laptop>
 <20100520070004.GH2516@laptop>
 <4BF57C78.4040606@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF57C78.4040606@colorfullife.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 08:16:24PM +0200, Manfred Spraul wrote:
> On 05/20/2010 09:00 AM, Nick Piggin wrote:
> >All the ipc ids and sequences are signed integers, so power of 2
> >sequence multiplier does not work so well. Convert it to use shifts,
> >which improves generated code particularly in ipc_lock/ipc_lock_check
> >fast paths.
> >
> Have you checked the asm output?

Yep, it's quite improved (although this isn't a particularly hot
path I thought it is a good cleanup).


> I would expect that gcc auto-optimizes constant divides by power-of-two.

It can't with signed I guess.
