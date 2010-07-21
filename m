Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0GUP1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:27:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab0GUP1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:27:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C470B46.4040604@kernel.org>
References: <4C470B46.4040604@kernel.org> <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com> <21485.1279717725@redhat.com>
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
Date: Wed, 21 Jul 2010 16:25:44 +0100
Message-ID: <15189.1279725944@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Each gcwq keeps track of currently running works in a hash table and looks
> whether the work in question is already executing before starting executing
> it.  It's a bit complex but as a work_struct may be freed once execution
> starts, the status needs to be tracked outside.

Thanks, that's what I wanted to know.

I presume this survives an executing work_struct being freed, reallocated and
requeued before the address of the work_struct is removed from the hash table?

I can see at least one way of doing this: marking the work_struct address in
the hash when the address becomes pending again so that the process of hash
removal will cause the work_struct to be requeued automatically.

David
