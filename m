Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030381Ab2CBR5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:57:21 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56513 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2CBR5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:57:19 -0500
Message-ID: <1330711026.3392.126.camel@aeonflux>
Subject: Re: [PATCH] Bluetooth: Silence static checker warning.
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        santosh nayak <santoshprasadnayak@gmail.com>, padovan@profusion.mobi,
        davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Ville Tervo <ville.tervo@nokia.com>
Date: Fri, 02 Mar 2012 09:57:06 -0800
In-Reply-To: <20120302110420.GH22598@mwanda>
References: <1330537602.3392.101.camel@aeonflux>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B6E88@saturn3.aculab.com>
	 <20120302110420.GH22598@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

> > How long has this code been in tree?
> > It isn't obvious to me that this change won't break code on BE systems
> > where the application code is already fixing the endianness.
> > 
> 
> It looks like we've had an endian bug since last February.
> 
> b62f328b8f20a "Bluetooth: Add server socket support for LE
> connection"
> 
> +               l2cap_pi(sk)->scid = la.l2_cid;
> 
> ->scid was cpu endian.

this is a bug. No questions asked.

However you can only exercise this code if you work with Bluetooth Low
Energy and that is not enabled by default since it is not fully finished
yet. CID is only used by Low Energy.

Bluetooth BR/EDR only uses PSM part of the socket address and that has
been endian safe.

Regards

Marcel


