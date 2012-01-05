Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2AESVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:21:16 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33276 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2AESVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:21:15 -0500
Date: Thu, 05 Jan 2012 13:21:04 -0500 (EST)
Message-Id: <20120105.132104.1867723912140416026.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: mikew@google.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH v1 1/2] virtio_net: Pass gfp flags when allocating
 rx buffers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <871urfc8md.fsf@rustcorp.com.au>
References: <20120104225223.18184.1537.stgit@mike2.sea.corp.google.com>
	<20120104225231.18184.96390.stgit@mike2.sea.corp.google.com>
	<871urfc8md.fsf@rustcorp.com.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 05 Jan 2012 10:21:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 05 Jan 2012 10:40:02 +1030

> On Wed, 04 Jan 2012 14:52:32 -0800, Mike Waychison <mikew@google.com> wrote:
>> Currently, the refill path for RX buffers will always allocate the
>> buffers as GFP_ATOMIC, even if we are in process context.  This will
>> fail to apply memory pressure as the worker thread will not contribute
>> to the freeing of memory.
>> 
>> Fix this by changing add_recvbuf_small to use the gfp variant allocator,
>> __netdev_alloc_skb_ip_align().
>> 
>> Signed-off-by: Mike Waychison <mikew@google.com>
> 
> OK, this is a no-brainer.  Thanks!  Dave, can you pick this up?
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Applied.
