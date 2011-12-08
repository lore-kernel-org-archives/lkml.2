Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab1LHH0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:26:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44951 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1LHH0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:26:24 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1112072314140.28419@chino.kir.corp.google.com>
References: <1323327732-30817-1-git-send-email-consul.kautuk@gmail.com>
	<alpine.DEB.2.00.1112072304010.28419@chino.kir.corp.google.com>
	<CAFPAmTSJDXD1KNVBUz75yN_CeCT9f_+W9CaRNN467LSyCD+WXg@mail.gmail.com>
	<alpine.DEB.2.00.1112072314140.28419@chino.kir.corp.google.com>
Date: Thu, 8 Dec 2011 12:56:22 +0530
Message-ID: <CAFPAmTSKXCiXNnFK0zR651ONju+ZBYE0qWUhCF9GXZRy=ieSJw@mail.gmail.com>
Subject: Re: [PATCH 1/1] vmalloc: purge_fragmented_blocks: Acquire spinlock
 before reading vmap_block
From: Kautuk Consul <consul.kautuk@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> That's intentional as an optimization, we don't care if
> vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS
> would speculatively be true after we grab vb->lock, we'll have to purge it
> next time instead.  We certainly don't want to grab vb->lock for blocks
> that aren't candidates, so this optimization is a singificant speedup.

Ah, I agree.
Anyway, the probability of there being too many vmap_blocks being
missed due to concurrent changes
is not quite high, so I guess its okay that a few vmap_blocks get
purged next time.

Thanks.
