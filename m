Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1JHIms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 04:42:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61693 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1JHImq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 04:42:46 -0400
Subject: Re: [PATCH v2 2/2] virtio-net: Prevent NULL dereference
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
In-Reply-To: <20111003190516.GD22427@redhat.com>
References: <1317220855-9352-1-git-send-email-levinsasha928@gmail.com>
	 <1317220855-9352-2-git-send-email-levinsasha928@gmail.com>
	 <20111003190516.GD22427@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 08 Oct 2011 10:40:11 +0200
Message-ID: <1318063211.7385.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 21:05 +0200, Michael S. Tsirkin wrote:
> I thought about this some more. If length was too large host is
> right now writing into pages that we have freed.
> That is very bad, and I don't know what do do with it,
> really not worth prettifying that IMO, NULL pointer is the least of our
> worries.
> 
> But, with mergeable buffers at least, and that is the main mode anyway,
> there is always a single page per buf, right?
> So I think we should change the code,
> and for mergeable buffers we shall only verify that
> length <= PAGE_SIZE.

In receive_mergeable() we already verify both 'page' being non-null and
length:

	if (len > PAGE_SIZE)
		len = PAGE_SIZE;

> 
> IOW copy a bit of code from page_to_skb(vi, page, len)
> to receive_mergeable, maybe add a common function
> if we need to avoid duplication.

-- 

Sasha.

