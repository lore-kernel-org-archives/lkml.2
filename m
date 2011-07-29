Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab1G2Muy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:50:54 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45850 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab1G2Mux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:50:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAJSP0QUV1C3O6SuXzFKMi5t61T+Qa-Yy2yWEevuuAvyQarJ47g@mail.gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
	<CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
	<4E325F98.5090308@gmail.com>
	<CAJSP0QX=mXvkZyeMx28iwVNDrKEZZVAZxLLOFRv62pu7byo6gw@mail.gmail.com>
	<4E32A105.6080509@gmail.com>
	<CAJSP0QUV1C3O6SuXzFKMi5t61T+Qa-Yy2yWEevuuAvyQarJ47g@mail.gmail.com>
Date: Fri, 29 Jul 2011 13:50:52 +0100
Message-ID: <CAJSP0QUbZ=RAkn_kbDupeA9QYYnzGd+u5M2duEg==e8ACjAqXg@mail.gmail.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block device
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hit a weirdness yesterday, just want to mention it in case you notice it too.

When running vanilla qemu-kvm I forgot to use aio=native.  When I
compared the results against virtio-blk-data-plane (which *always*
uses Linux AIO) I was surprised to find average 4k read latency was
lower and the standard deviation was also lower.

So from now on I will run tests both with and without aio=native.
aio=native should be faster and if I can reproduce the reverse I'll
try to figure out why.

Stefan
