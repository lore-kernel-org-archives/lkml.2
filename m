Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2CHRx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:53:27 -0500
Received: from senator.holtmann.net ([87.106.208.187]:53274 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2CHRxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:53:24 -0500
Message-ID: <1331229183.14217.10.camel@aeonflux>
Subject: Re: Resend: [PATCH] Bluetooth: Fix Endian Bug.
From: Marcel Holtmann <marcel@holtmann.org>
To: Gustavo Padovan <padovan@profusion.mobi>
Cc: santosh nayak <santoshprasadnayak@gmail.com>, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 08 Mar 2012 09:53:03 -0800
In-Reply-To: <20120308053320.GD3998@joana>
References: <1330622196-12967-1-git-send-email-santoshprasadnayak@gmail.com>
	 <20120308053320.GD3998@joana>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

> > Fix network to host endian conversion for L2CAP chan id.
> > 
> > Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> > ---
> >  net/bluetooth/l2cap_sock.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> > index 401d942..86d5067 100644
> > --- a/net/bluetooth/l2cap_sock.c
> > +++ b/net/bluetooth/l2cap_sock.c
> > @@ -82,7 +82,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
> >  	}
> >  
> >  	if (la.l2_cid)
> > -		err = l2cap_add_scid(chan, la.l2_cid);
> > +		err = l2cap_add_scid(chan, __le16_to_cpu(la.l2_cid));
> 
> This is kind weird, la.l2_cid comes from the user, so it is already in host
> endian. No need for convertions here.

CID and PSM are provided in little endian by user space.

Regards

Marcel


