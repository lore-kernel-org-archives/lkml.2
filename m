Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1CMRlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:41:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60198 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab1CMRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WB/y/RG0loKU66Vwwu2P1i2wzvZripedDSsoaHLWv3BC13S381NbfP/uHmJy6lr7v9
         fFTVt3EkdHrGyp9qa4DcI24F7N4kV5U6GXc19HXtVxSxPDDiX5+P5WqCdAWCB4sj/JHK
         3Tm+CzUPo6G+ccJt4aX4+yktLjvZM/q67MepM=
Subject: Re: [PATCH 3/3] vhost-net: use lock_sock_fast() in peek_head_len()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, virtualization@lists.osdl.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110313164359.GA32562@redhat.com>
References: <20110117081058.18900.67456.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
	 <20110117081117.18900.48672.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
	 <20110313150646.GA30494@redhat.com>
	 <1300031570.2761.22.camel@edumazet-laptop>
	 <20110313161915.GB30642@redhat.com>
	 <1300033927.2761.26.camel@edumazet-laptop>
	 <20110313164359.GA32562@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Mar 2011 18:41:32 +0100
Message-ID: <1300038092.2761.41.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 13 mars 2011 à 18:43 +0200, Michael S. Tsirkin a écrit :
> On Sun, Mar 13, 2011 at 05:32:07PM +0100, Eric Dumazet wrote:
> > Le dimanche 13 mars 2011 à 18:19 +0200, Michael S. Tsirkin a écrit :
> > 
> > > Other side is in drivers/net/tun.c and net/packet/af_packet.c
> > > At least wrt tun it seems clear socket is not locked.
> > 
> > Yes (assuming you refer to tun_net_xmit())
> > 
> > > Besides queue, dequeue seems to be done without socket locked.
> > > 
> > 
> > It seems this code (assuming you speak of drivers/vhost/net.c ?) has
> > some races indeed.
> > 
> 
> Hmm. Any more besides the one fixed here?
> 

If writers and readers dont share a common lock, how can they reliably
synchronize states ?

For example, the check at line 420 seems unsafe or useless.

skb_queue_empty(&sock->sk->sk_receive_queue)



