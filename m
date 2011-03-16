Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1CPUvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:51:47 -0400
Received: from science.horizon.com ([71.41.210.146]:13128 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751757Ab1CPUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:51:40 -0400
Date: 16 Mar 2011 16:51:39 -0400
Message-ID: <20110316205139.2035.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, rientjes@google.com
Subject: Re: [PATCH 5/8] mm/slub: Factor out some common code.
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mpm@selenic.com, penberg@cs.helsinki.fi
In-Reply-To: <alpine.DEB.2.00.1103161308410.11002@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Where's your signed-off-by?

Somewhere under the pile of crap on my desk. :-)
(More to the point, waiting for me to think it's good enough to submit
For Real.)

> Nice cleanup.
> 
> "flag" should be unsigned long in all of these functions: the constants 
> are declared with UL suffixes in slab.h.

Actually, I did that deliberately.  Because there's a problem I keep
wondering about, which repeats many many times in the kernel:

*Why* are they unsigned long?  That's an awkward type: 32 bits on many
architectures, so we can't portably assign more than 32 bits, and on
platforms where it's 64 bits, the upper 32 are just wasting space.
(And REX prefixes on x86-64.)

Wouldn't it be a better cleanup to convert the whole lot to unsigned
or u32?
