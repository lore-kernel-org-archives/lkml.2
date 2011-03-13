Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab1CMQor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 12:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab1CMQoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 12:44:44 -0400
Date: Sun, 13 Mar 2011 18:43:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, virtualization@lists.osdl.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] vhost-net: use lock_sock_fast() in peek_head_len()
Message-ID: <20110313164359.GA32562@redhat.com>
References: <20110117081058.18900.67456.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
 <20110117081117.18900.48672.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
 <20110313150646.GA30494@redhat.com>
 <1300031570.2761.22.camel@edumazet-laptop>
 <20110313161915.GB30642@redhat.com>
 <1300033927.2761.26.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300033927.2761.26.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 05:32:07PM +0100, Eric Dumazet wrote:
> Le dimanche 13 mars 2011 à 18:19 +0200, Michael S. Tsirkin a écrit :
> 
> > Other side is in drivers/net/tun.c and net/packet/af_packet.c
> > At least wrt tun it seems clear socket is not locked.
> 
> Yes (assuming you refer to tun_net_xmit())
> 
> > Besides queue, dequeue seems to be done without socket locked.
> > 
> 
> It seems this code (assuming you speak of drivers/vhost/net.c ?) has
> some races indeed.
> 

Hmm. Any more besides the one fixed here?

-- 
MST
