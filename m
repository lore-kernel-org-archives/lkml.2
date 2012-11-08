Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2KHCZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:25:41 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52568 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2KHCZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:25:39 -0500
MIME-Version: 1.0
In-Reply-To: <1352331754.2748.14.camel@edumazet-glaptop>
References: <CAODwPW9kiG-jo=n0zedv5KT-8-gJcEUrdC3F2mAEjt78tne18g@mail.gmail.com>
	<1352316791-16491-1-git-send-email-jwerner@chromium.org>
	<1352317219.5552.6.camel@edumazet-glaptop>
	<CAODwPW8mBJspF3k5SCBR-BShNvBLQpD-vyhLRh5Cq-4h=VZDgg@mail.gmail.com>
	<1352331192.2748.10.camel@edumazet-glaptop>
	<1352331754.2748.14.camel@edumazet-glaptop>
Date: Wed, 7 Nov 2012 18:25:37 -0800
X-Google-Sender-Auth: DZXRrZZxvTVbidqaQscyFZfTIy0
Message-ID: <CAODwPW90mZuCDgYPZEJtYNOGGt752VpP=S_EYACUCGua_x=WjA@mail.gmail.com>
Subject: Re: [PATCH] tcp: Avoid infinite loop on recvmsg bug
From: Julius Werner <jwerner@chromium.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>, Dave Jones <davej@redhat.com>,
        Sameer Nanda <snanda@chromium.org>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So you probably are fighting a bug we already fixed in upstream kernel.
>
> (commit c8628155ece363 "tcp: reduce out_of_order memory use" did not
> played well with cloned skbs.)
>
> This issue was already discussed on netdev in the past.

Thanks for the hint. Unfortunately, we have not pulled c8628 into our
tree yet, so that's not it. Is there another point where the cloned
skb or the faked truesize might make it break? We have been running
this test with that hardware some 30 times in the last months and only
seen it once, so it cannot be that common.

I have noticed that you have already proposed a patch to repair
smsc95xx (replacing the clone with a copy) on this list a few times...
what's the status on that? Will it be committed eventually or did you
abandon that approach?

Regardless of that, I still think that the bug handling in tcp_recvmsg
should be updated in one way or the other.
