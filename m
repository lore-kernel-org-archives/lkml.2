Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0IQVtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 17:49:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:42686 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0IQVtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 17:49:42 -0400
Subject: Re: memory barrier question
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
References: <E1OwEjQ-0006wS-MU@pomaz-ex.szeredi.hu>
	 <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu> <3777.1284638136@redhat.com>
	 <6383.1284647456@redhat.com> <20100916150356.GD2462@linux.vnet.ibm.com>
	 <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu>
	 <20100916163708.GG2462@linux.vnet.ibm.com>
	 <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
	 <1284656978.26423.11.camel@mulgrave.site>
	 <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Sep 2010 07:49:08 +1000
Message-ID: <1284760148.30449.107.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Right but in the concrete namei example I can't see how a compiler
> optimization can make a difference.  The order of the loads is quite
> clear:
> 
>    LOAD inode = next.dentry->inode
>    if (inode != NULL)
>    	LOAD inode->f_op
> 
> What is there the compiler can optimize?

Those two loads depend on each other, I don't think any implementation
can re-order them. In fact, such data dependency is typically what is
used to avoid having barriers in some cases. The second load cannot be
issued until the value from the first one is returned.

Cheers,
Ben.


