Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926Ab1HBEQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:16:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56683 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab1HBEQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:16:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=melnSew/xjVB6CsygSnRv9lerEP5CgFYTNiXfsStTaJ51KkgCfrGlZP2n4tNCuRZO
	PWzMfKK1/eba/6CI61rhg==
Date: Mon, 1 Aug 2011 21:15:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p3 0/7] SLUB: [RFC] Per cpu partial lists V3
In-Reply-To: <20110801162823.755182213@linux.com>
Message-ID: <alpine.DEB.2.00.1108012112420.7373@chino.kir.corp.google.com>
References: <20110801162823.755182213@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Christoph Lameter wrote:

> Performance:
> 
> 				Before		After
> ./hackbench 100 process 200000
> 				Time: 2299.072	1742.454
> ./hackbench 100 process 20000
> 				Time: 224.654	182.393
> ./hackbench 100 process 20000
> 				Time: 227.126	182.780
> ./hackbench 100 process 20000
> 				Time: 219.608	182.899
> ./hackbench 10 process 20000
> 				Time: 21.769	18.756
> ./hackbench 10 process 20000
> 				Time: 21.657	18.938
> ./hackbench 10 process 20000
> 				Time: 23.193	19.537
> ./hackbench 1 process 20000
> 				Time: 2.337	2.263
> ./hackbench 1 process 20000
> 				Time: 2.223	2.271
> ./hackbench 1 process 20000
> 				Time: 2.269	2.301
> 

This applied nicely to Linus' tree so I've moved to testing atop that 
rather than slub/lockless on the same netperf testing environment as the 
slab vs. slub comparison.  The benchmarking completed without error and 
here are the results:

	threads		before		after
	 16		75509		75443  (-0.1%)
	 32		118121		117558 (-0.5%)
	 48		149997		149514 (-0.3%)
	 64		185216		186772 (+0.8%)
	 80		221195		222612 (+0.6%)
	 96		239732		241089 (+0.6%)
	112		261967		266643 (+1.8%)
	128		272946		281794 (+3.2%)
	144		279202		289421 (+3.7%)
	160		285745		297216 (+4.0%)

So the patchset certainly looks helpful, especially if it improves other 
benchmarks as well.

I'll review the patches individually, starting with the cleanup patches 
that can hopefully be pushed quickly while we discuss per-cpu partial 
lists further.
