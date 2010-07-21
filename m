Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0GUPrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:47:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab0GUPrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:47:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C4712B4.9040706@kernel.org>
References: <4C4712B4.9040706@kernel.org> <4C470B46.4040604@kernel.org> <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com> <21485.1279717725@redhat.com> <15189.1279725944@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        torvalds@linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
Date: Wed, 21 Jul 2010 16:45:25 +0100
Message-ID: <15482.1279727125@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> It will unnecessarily stall the execution of the new work if the last
> work is still running but nothing will be broken correctness-wise.

That's fine.  Better that than risk unexpected reentrance.  You could add a
function to allow an executing work item to yield the hash entry to indicate
that the work_item that invoked it has been destroyed, but it's probably not
worth it, and it has scope for mucking things up horribly if used at the wrong
time.

I presume also that if a work_item being executed on one work queue is queued
on another work queue, then there is no non-reentrancy guarantee (which is
fine; if you don't like that, don't do it).

David
