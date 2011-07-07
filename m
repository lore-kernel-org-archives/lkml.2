Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab1GGTFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:05:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49496 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1GGTFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:05:07 -0400
Subject: Re: [slub p2 0/4] SLUB: [RFC] Per cpu partial lists V2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20110620153244.214038140@linux.com>
References: <20110620153244.214038140@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 07 Jul 2011 22:05:03 +0300
Message-ID: <1310065503.21902.61.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 10:32 -0500, Christoph Lameter wrote:
> The following patchset applied on top of the lockless patchset V7. It
> introduces per cpu partial lists which allow a performance increase of
> around ~15 during contention for the nodelock (can be tested using
> hackbench).
> 
> These lists help to avoid per nodelocking overhead. Allocator latency
> could be further reduced by making these operations work without
> disabling interrupts (like the fastpath and the free slowpath) as well as
> implementing better ways of handling ther cpu array with partial pages.
> 
> I am still not satisfied with the cleanliness of the code after these
> changes. Some review with suggestions as to how to restructure the
> code given these changes in operations would be appreciated.
> 
> It is interesting to note that BSD has gone to a scheme with partial
> pages only per cpu (source: Adrian). Transfer of cpu ownerships is
> done using IPIs. Probably too much overhead for our taste. The use
> of a few per cpu partial pages looks to be beneficial though.
> 
> Note that there is no performance gain when there is no contention.
> 
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

Impressive numbers! David, comments on the series?

			Pekka

