Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0ITQCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 12:02:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52652 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab0ITQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 12:02:13 -0400
To: paulmck@linux.vnet.ibm.com
CC: James.Bottomley@HansenPartnership.com, miklos@szeredi.hu,
        benh@kernel.crashing.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-reply-to: <20100920012915.GI3060@linux.vnet.ibm.com>
	(paulmck@linux.vnet.ibm.com)
Subject: Re: memory barrier question
References: <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
 <1284656978.26423.11.camel@mulgrave.site>
 <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
 <1284760148.30449.107.camel@pasglop>
 <20100917231222.GA3060@linux.vnet.ibm.com>
 <1284864421.30449.113.camel@pasglop>
 <20100919152638.GF3060@linux.vnet.ibm.com>
 <E1OxQIg-0005Nw-WE@pomaz-ex.szeredi.hu>
 <20100919215909.GG3060@linux.vnet.ibm.com>
 <1284944316.2957.795.camel@mulgrave.site> <20100920012915.GI3060@linux.vnet.ibm.com>
Message-Id: <E1OxioY-0006nd-M9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 20 Sep 2010 18:01:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Sep 2010, Paul E. McKenney wrote:
> > > Again, please put at least an ACCESS_ONCE() in.  Trivial to do now,
> > > possibly saving much pain and headache later on.
> > 
> > OK, lost you here.  ACCESS_ONCE() is only needed in certain situations
> > (like list traversal) because some compilers can reload cached values
> > across an explicit barrier (which isn't here).
> 
> ACCESS_ONCE() also tells the compiler not to try to guess.

If the code is written like this:

	if (ACCESS_ONCE(dentry->d_inode)) {
		blah = dentry->d_inode->i_some_field
		...
	}

does the compiler guarantee anything or does it need a full compiler
barrier to prevent reordering?

Because that pattern is, again, pretty much all over the place.  Yeah
it can be rewritten but that's not always feasable since it's
difficult to audit, would possibly need extra function arguments,
etc...

Thanks,
Miklos
