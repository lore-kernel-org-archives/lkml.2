Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab2JDQuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:50:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55447 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab2JDQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:50:13 -0400
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109
 __alloc_pages_nodemask+0x1d4/0x68c()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: mbizon@freebox.fr
Cc: David Madore <david+ml@madore.org>, Francois Romieu <romieu@fr.zoreil.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <1349366521.2532.12.camel@sakura.staff.proxad.net>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net>
	 <alpine.LSU.2.00.1208311900330.1936@eggly.anvils>
	 <1349366521.2532.12.camel@sakura.staff.proxad.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Oct 2012 18:50:06 +0200
Message-ID: <1349369406.16011.82.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 18:02 +0200, Maxime Bizon wrote:
> O
> 
> Since skb_recycle() resets skb->data using (skb->head + NET_SKB_PAD), a
> recycled skb going multiple times through a path that needs to expand
> skb head will get bigger and bigger each time, and you eventually end up
> with an allocation failure.
> 

Because there is not enough headroom ?

> An idea to fix this would be to pass needed skb size to skb_resize() and
> set skb->data to MIN(NET_SKB_PAD, (skb->end - skb->head - skb_size) / 2)

I am trying to decode this but I cant ;)

What is skb_resize() ?
and what do you mean setting skb->data to MIN(NET_SKB_PAD, (skb->end -
skb->head - skb_size) / 2)

Care to explain again your idea ?

Thanks !



