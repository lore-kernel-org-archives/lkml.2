Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab2KIDaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 22:30:05 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39179 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236Ab2KIDaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 22:30:02 -0500
Subject: Re: [PATCH] tcp: Avoid infinite loop on recvmsg bug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>, Dave Jones <davej@redhat.com>,
        Sameer Nanda <snanda@chromium.org>,
        Mandeep Singh Baines <msb@chromium.org>
In-Reply-To: <CAODwPW90mZuCDgYPZEJtYNOGGt752VpP=S_EYACUCGua_x=WjA@mail.gmail.com>
References: <CAODwPW9kiG-jo=n0zedv5KT-8-gJcEUrdC3F2mAEjt78tne18g@mail.gmail.com>
	 <1352316791-16491-1-git-send-email-jwerner@chromium.org>
	 <1352317219.5552.6.camel@edumazet-glaptop>
	 <CAODwPW8mBJspF3k5SCBR-BShNvBLQpD-vyhLRh5Cq-4h=VZDgg@mail.gmail.com>
	 <1352331192.2748.10.camel@edumazet-glaptop>
	 <1352331754.2748.14.camel@edumazet-glaptop>
	 <CAODwPW90mZuCDgYPZEJtYNOGGt752VpP=S_EYACUCGua_x=WjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Nov 2012 19:29:56 -0800
Message-ID: <1352431796.19779.536.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 18:25 -0800, Julius Werner wrote:
> > So you probably are fighting a bug we already fixed in upstream kernel.
> >
> > (commit c8628155ece363 "tcp: reduce out_of_order memory use" did not
> > played well with cloned skbs.)
> >
> > This issue was already discussed on netdev in the past.
> 
> Thanks for the hint. Unfortunately, we have not pulled c8628 into our
> tree yet, so that's not it. Is there another point where the cloned
> skb or the faked truesize might make it break? We have been running
> this test with that hardware some 30 times in the last months and only
> seen it once, so it cannot be that common.

Update : Chrome OS current tree is based on 3.4 and really needed the
patch :

https://gerrit.chromium.org/gerrit/#/c/37666/



