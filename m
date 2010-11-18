Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab0KRNkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:40:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43286 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab0KRNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:40:39 -0500
Date: Thu, 18 Nov 2010 14:40:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        acme@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf: Fix compilation on gcc 4.0.2
Message-ID: <20101118134038.GE12667@basil.fritz.box>
References: <1290077461-12321-1-git-send-email-andi@firstfloor.org>
 <1290077461-12321-2-git-send-email-andi@firstfloor.org>
 <1290078937.2109.1345.camel@laptop>
 <20101118133112.GC12667@basil.fritz.box>
 <1290087489.2781.121.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290087489.2781.121.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:38:09PM +0100, Eric Dumazet wrote:
> Le jeudi 18 novembre 2010 à 14:31 +0100, Andi Kleen a écrit :
> > > Should we be using more of the kernel makefile magic to detect this?
> > 
> > In theory yes, but the two warnings didn't seem to be too useful
> > to me so it's probably not worth it just for those two.
> > 
> > -Andi
> > 
> 
> Is the second case because of the __always_inline in
> util/include/linux/bitops.h ?

I think so.

> 
> Not sure why its needed for test_bit() ?

Because it generates terrible code when not inlined
and apparently some gcc versions of times past didn't
in some cases.

-Andi
