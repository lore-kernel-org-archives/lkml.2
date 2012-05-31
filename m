Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2EaGUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:20:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60844 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2EaGUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:20:37 -0400
Subject: Re: [PATCH] net: sock: validate data_len before allocating skb in
 sock_alloc_send_pskb()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <4FC70BA8.5060200@redhat.com>
References: <20120530054702.6146.8503.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <1338360383.2760.84.camel@edumazet-glaptop>
	 <20120530.030205.1337682162603770949.davem@davemloft.net>
	 <4FC708EE.2020908@redhat.com> <20120531060201.GA13158@redhat.com>
	 <4FC70BA8.5060200@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 May 2012 08:20:32 +0200
Message-ID: <1338445232.2760.1171.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 14:11 +0800, Jason Wang wrote:

> Not affected, only code duplication. It's no harm the check the data_len 
> again for packet sockets, so better to unify the code and fix the issue 
> in one place?

As a matter of fact, we currently allocate order-0 pages, but it could
be nice trying to use order-1 or order-2 pages, on arches where
PAGE_SIZE is so small (4096 bytes)

So lets do this test in sock_alloc_send_pskb() to allow future changes.

af_unix is kind of special, because it tries to lower risk of high order
linear allocation failures. And for small sizes, it wants linear skbs to
have no performance regression (prior kernels were allocating linear
skbs)



