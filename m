Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0F2Vi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:38:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab0F2Vi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:38:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C2A2688.1020206@kernel.org>
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> 
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, Arjan van de Ven <arjan@linux.intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 34/35] async: use workqueue for worker pool
Date: Tue, 29 Jun 2010 22:37:35 +0100
Message-ID: <25085.1277847455@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Hmmm... workqueue workers are bound to certain cpu, so if you schedule
> a work on a specific CPU, it will run there.

That's my main problem with using cmwq to replace slow-work.

> Once a cpu gets saturated, the issuing thread will be moved elsewhere.

Assuming that the issuing thread isn't bound by the condition specified in the
previous sentence...

David
