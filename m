Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab0LCOql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:46:41 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50814 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab0LCOqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iEtBAcHmc2nSODX5jx1wlBzxNPlHyCcZ66jJLaTZ1zAKU0nTDqv1XMHIX3GlYGvEOC
         i6I9eLjdkGSeFdZZ3BNYM5reDsMx85H5JF7kvPOhjvJjBAZPF36dz1Yu6OnpZk/Yhyw9
         rPonBO4aS8TgRB5YhfyNRKIG9ggqMNDLd8Mfg=
Subject: Re: unable to handle kernel NULL pointer dereference in skb_dequeue
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrej Ota <andrej@ota.si>
Cc: linux-kernel@vger.kernel.org, gvs@zemos.net,
        Rami Rosen <ramirose@gmail.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <aa43945b38cee751a8231084866b074d@192.168.253.23>
References: <0fe401cb92e7$85ba2260$912e6720$@si>
	 <1291381791.2897.250.camel@edumazet-laptop>
	 <aa43945b38cee751a8231084866b074d@192.168.253.23>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 15:46:35 +0100
Message-ID: <1291387595.2897.350.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 03 décembre 2010 à 15:37 +0100, Andrej Ota a écrit :
> >> Patch that works for me is below. Now I only hope I haven't
> >> (re)introduced a memory leak...
> 
> > Problem comes from commit 55c95e738da85 (fix return value of
> > __pppoe_xmit() method)
> > 
> > I am not sure patch is OK
> 
> 
> Me neither. That's why I wrote "works for me". All I dare say is that it
> works better than current code and is probably no worse than it was before
> above mentioned commit. Apart from that, there is no point in having return
> value for __pppoe_xmit if return value isn't needed.
> 
> Easiest way of triggering this BUG is by terminating PPPoE on the server
> side, which then hits "if (!dev) { goto abort; }". This in turn calls
> "kfree_skb(skb); return 0;" which returns to pppoe_rcv_core which then
> goto-s to "abort_put" which again calls "kfree_skb(skb)". Voila the bug.
> 
> I don't know how to trigger "if (skb_cow_head(skb, ..." to see if I have
> just caused another BUG. However, if I read file comments at the top, I see
> a comment from 19/07/01 stating that I have to delete original skb if code
> succeeds and never delete it on failure. About the skb copy mentioned in
> the same comment, I don't know. 2001 was many commits ago.

Well, all I wanted to say was that _I_ was not sure, but probably other
network guys have a better diagnostic.

Rami, could you re-explain the rationale of your patch ?

Thanks


