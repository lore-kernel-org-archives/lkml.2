Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1CFAuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 19:50:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:60536 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1CFAuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 19:50:23 -0500
Subject: Re: [RFC] memblock; Properly handle overlaps
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <4D72C552.4050406@kernel.org>
References: <1299297946.8833.931.camel@pasglop>
	 <4D71CE24.1090302@kernel.org> <1299311788.8833.937.camel@pasglop>
	 <4D728B8C.2080803@kernel.org> <1299361063.8833.953.camel@pasglop>
	 <4D72B2D0.3080700@kernel.org> <1299363583.8833.964.camel@pasglop>
	 <4D72C552.4050406@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 11:49:54 +1100
Message-ID: <1299372594.8833.966.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-05 at 15:20 -0800, Yinghai Lu wrote:
> 
> maybe we can omit rgn->size == 0 checking here.
> with that case, dummy array will go though to some extra checking.
> 
> if (rgn->base <= base && rend >= end)
> if (base < rgn->base && end >= rgn->base) {
> if (base <= rend && end >= rend) {
> 
> but we can spare more checking regarding
>         rgn->size == 0

Well, the array can be collasped to dummy by the removal of the last
block when doing a top overlap, then on the next loop around, we can
potentially hit the if (base <= rend && end >= rend) test, and loop
again no ?

I'd rather keep the test in .. won't hurt.

Cheers,
Ben.

