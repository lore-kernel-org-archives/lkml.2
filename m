Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab0KAOQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 10:16:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35361
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756439Ab0KAOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:16:24 -0400
Date: Mon, 01 Nov 2010 07:16:48 -0700 (PDT)
Message-Id: <20101101.071648.112608839.davem@davemloft.net>
To: mst@redhat.com
Cc: herbert@gondor.hengli.com.au, eric.dumazet@gmail.com, joe@perches.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] tun: remove of user-controlled memory allocation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101101082749.GA25860@redhat.com>
References: <20101101082749.GA25860@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 1 Nov 2010 10:27:49 +0200

> Untested, this is just an RFC.
> 
> tun does a kmalloc where userspace controls the length. This will
> produce warnings in kernel log when the length is too large, or might
> block for a long while. A simple fix is to avoid the allocatiuon
> altogether, and copy from user in a loop.
> 
> However, with this patch an illegal address passed to the ioctl might
> leave the filter disabled.  Is this something we care about?  If
> yes we could recover by creating a copy of the filter.  Thoughts?
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I think the key issue in situations like this is simply to make
sure that reasonable things that worked before, still do afterwards.

And I think your patch does that, so it's fine as far as I can tell.
