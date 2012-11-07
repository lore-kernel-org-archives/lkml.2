Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2KGXdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:33:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58448 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2KGXdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:33:15 -0500
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
In-Reply-To: <CAODwPW8mBJspF3k5SCBR-BShNvBLQpD-vyhLRh5Cq-4h=VZDgg@mail.gmail.com>
References: <CAODwPW9kiG-jo=n0zedv5KT-8-gJcEUrdC3F2mAEjt78tne18g@mail.gmail.com>
	 <1352316791-16491-1-git-send-email-jwerner@chromium.org>
	 <1352317219.5552.6.camel@edumazet-glaptop>
	 <CAODwPW8mBJspF3k5SCBR-BShNvBLQpD-vyhLRh5Cq-4h=VZDgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 15:33:12 -0800
Message-ID: <1352331192.2748.10.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 13:14 -0800, Julius Werner wrote:
> > What I find very sad in all this is that you didnt mention the driver
> > that was triggering this bug.
> 
> Sorry, I was just trying to keep this thread focussed on one patch.
> The bug report that led me to this is publicly accessible at
> http://crosbug.com/35827. We have encountered the problem only once,
> on an Acer AC700 Chromebook that ran automated tests. The ethernet
> interface for the offending socket was provided by a USB-to-Ethernet
> dongle using the smsc95xx/usbnet module (v1.0.4).

This driver uses interesting skb_clone() games and skb->truesize lies :

skb->truesize = size + sizeof(struct sk_buff);

So you probably are fighting a bug we already fixed in upstream kernel.

(commit c8628155ece363 "tcp: reduce out_of_order memory use" did not
played well with cloned skbs.)

This issue was already discussed on netdev in the past.



