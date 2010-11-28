Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab0K1KCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 05:02:15 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:48532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab0K1KCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 05:02:14 -0500
Subject: Re: [PATCH 4/4] zd1211rw: remove unnecessary [kv][mcz]alloc casts
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1290937845.16349.16.camel@Joe-Laptop>
References: <cover.1290934782.git.joe@perches.com>
	 <704bdd89d630b364043ac7a9ec0a110d311a17a2.1290934782.git.joe@perches.com>
	 <1290935566.3467.0.camel@jlt3.sipsolutions.net>
	 <1290936047.16349.13.camel@Joe-Laptop>
	 <1290936606.3467.2.camel@jlt3.sipsolutions.net>
	 <1290937845.16349.16.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Nov 2010 11:02:07 +0100
Message-ID: <1290938527.3467.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 01:50 -0800, Joe Perches wrote:
> On Sun, 2010-11-28 at 10:30 +0100, Johannes Berg wrote:
> > On Sun, 2010-11-28 at 01:20 -0800, Joe Perches wrote:
> > > On Sun, 2010-11-28 at 10:12 +0100, Johannes Berg wrote:
> > > > On Sun, 2010-11-28 at 01:05 -0800, Joe Perches wrote:
> > > > > diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
> > > > > @@ -117,8 +117,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
> > > > >  	/* Allocate a single memory block for values and addresses. */
> > > > >  	count16 = 2*count;
> > > > > -	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
> > > > > -		                   GFP_KERNEL);
> > > > > +	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)), GFP_KERNEL);
> > > > I believe this is on purpose for sparse.
> > > Perhaps in a previous version, but not now.
> > How do you know? I thought sparse was pretty much not reliable after the
> > first error it prints.
> 
> Good memory you have Johannes...
> 
> http://marc.info/?l=linux-netdev&m=117113743902549&w=3

I, err, not really, all this isn't making a whole lot of sense to me
right now :-)
The only thing I remembered was that there was something weird with
zd_addr_t ...

Did sparse become more reliable in face of errors?

johannes

