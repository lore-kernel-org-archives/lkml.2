Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2FUGZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:25:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:47927 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2FUGZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:25:16 -0400
Message-ID: <1340259896.3942.2.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the final tree
 (powerpc related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Alan Modra <amodra@bigpond.net.au>
Date: Thu, 21 Jun 2012 16:24:56 +1000
In-Reply-To: <1340256961.1998.11.camel@concordia>
References: <20120620175014.a822a766e0f91f7b44f48fa0@canb.auug.org.au>
	 <1340256961.1998.11.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 15:36 +1000, Michael Ellerman wrote:
> 
> powerpc64-linux-ld: /src/next/net/openvswitch/vport-netdev.c:189:(.text+0x89b990): 
>         sibling call optimization to `_restgpr0_28' does not allow automatic multiple TOCs;
>         recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `_restgpr0_28' extern
> 
> 
> And those are generated calls so I don't see how we can fix them.

Is this a module ? We should really be linking that stuff directly with the module....

The interesting thing is that we do build everything except a handful of
files with -mminimal-toc unless something's wrong with our main Makefile....

Can you show the full build command that triggers the above ?

Cheers,
Ben.


