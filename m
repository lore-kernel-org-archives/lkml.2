Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2BWBfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 20:35:09 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37894 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab2BWBfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 20:35:07 -0500
X-Sasl-enc: f11UGPJpKTtBqBap3vsQGu7wCRcxfnhcJad1Rq7QUd5GCTWN8vvNd38LaA 1329960906
Message-ID: <1329960902.2244.2.camel@perseus.themaw.net>
Subject: Re: compat: autofs v5 packet size ambiguity - update
From: Ian Kent <raven@themaw.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 23 Feb 2012 09:35:02 +0800
In-Reply-To: <4F45062C.8000104@zytor.com>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
	  <20120221.221609.218135609185671883.davem@davemloft.net>
	  <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
	  <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
	  <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
	  <1329889428.2193.45.camel@perseus.themaw.net>
	  <1329890027.2193.48.camel@perseus.themaw.net>
	  <1329890251.2193.50.camel@perseus.themaw.net>
	 <1329903139.2193.66.camel@perseus.themaw.net> <4F45062C.8000104@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 07:13 -0800, H. Peter Anvin wrote:
> On 02/22/2012 01:32 AM, Ian Kent wrote:
> > 
> > Oh, DOH ... 
> > 
> > The process mounting the autofs mount is passing the pipe it will use
> > for communication via a mount option so we can do this right in
> > fill_super.
> > 
> 
> Does that mean that the autofs v5 daemon calls mount() by itself, unlike
> the older autofs daemon?  Otherwise you're reading the compatness of
> /bin/mount...

Version 5 does, yes.

There was nothing to be gained by the extra overhead of calling mount(8)
since I wanted to minimize mtab usage and contention, and didn't want
these showing up in mtab either.

> 
> 	-hpa
> 


