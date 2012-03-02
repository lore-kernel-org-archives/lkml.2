Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab2CBJQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:16:30 -0500
Received: from mx0.aculab.com ([213.249.233.131]:50851 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757836Ab2CBJQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:16:26 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Bluetooth: Silence static checker warning.
Date: Fri, 2 Mar 2012 09:15:37 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E88@saturn3.aculab.com>
In-Reply-To: <1330537602.3392.101.camel@aeonflux>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Bluetooth: Silence static checker warning.
Thread-Index: Acz3CgiybSRic4PYSrewGorzQNz0AwBSp+ig
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Marcel Holtmann" <marcel@holtmann.org>,
        "santosh nayak" <santoshprasadnayak@gmail.com>
Cc: <padovan@profusion.mobi>, <davem@davemloft.net>,
        <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
X-OriginalArrivalTime: 02 Mar 2012 09:15:37.0243 (UTC) FILETIME=[07B9D6B0:01CCF855]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > > diff --git a/net/bluetooth/l2cap_sock.c
b/net/bluetooth/l2cap_sock.c
> > > index 401d942..d206321 100644
> > > --- a/net/bluetooth/l2cap_sock.c
> > > +++ b/net/bluetooth/l2cap_sock.c
> > > @@ -82,7 +82,7 @@ static int l2cap_sock_bind(struct socket *sock,
struct sockaddr *addr, int alen)
> > >  	}
> > >  
> > >  	if (la.l2_cid)
> > > -		err = l2cap_add_scid(chan, la.l2_cid);
> > > +		err = l2cap_add_scid(chan, __le16_to_cpu(la.l2_cid));
> > >  	else
> > >  		err = l2cap_add_psm(chan, &la.l2_bdaddr, la.l2_psm);
> > >  
> > > @@ -123,7 +123,8 @@ static int l2cap_sock_connect(struct socket
*sock, struct sockaddr *addr, int al
> > >  	if (la.l2_cid && la.l2_psm)
> > >  		return -EINVAL;
> > >  
> > > -	err = l2cap_chan_connect(chan, la.l2_psm, la.l2_cid,
&la.l2_bdaddr);
> > > +	err = l2cap_chan_connect(chan, la.l2_psm,
__le16_to_cpu(la.l2_cid),
> > > +				&la.l2_bdaddr);
> > >  	if (err)
> > >  		goto done;
> > 
> > I am not sure about this one. Need to go back and read through the
> > source code. The value provided from userspace is already in the
right
> > host endian. Could be that we mess up our internal classification.
And
> > instead of adding __le16_to_cpu we should fix its classification.
> 
> I confused myself here, so the provided PSM and CID values coming from
> userspace are little endian. Patch is correct.

How long has this code been in tree?
It isn't obvious to me that this change won't break code on BE systems
where the application code is already fixing the endianness.

	David


