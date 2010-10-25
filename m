Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0JYVjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:39:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab0JYVjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:39:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20101025212706.27798.23957.stgit@warthog.procyon.org.uk>
References: <20101025212706.27798.23957.stgit@warthog.procyon.org.uk>
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, Tejun Heo <tj@kernel.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [Linux-am33-list] [PATCH] workqueue: Fix alignment calculation in alloc_cwqs()
Date: Mon, 25 Oct 2010 22:38:47 +0100
Message-ID: <3386.1288042727@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> +	const size_t align =
> +		max_t(size_t, 1 << (WORK_STRUCT_FLAG_BITS - BITS_PER_BYTE),
> +		      __alignof__(unsigned long long));

Actually, no, that's not right either.  Need to subtract log2(BITS_PER_BYTE).

David
