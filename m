Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab0IQXM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:12:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39895 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab0IQXMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:12:25 -0400
Date: Fri, 17 Sep 2010 16:12:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: memory barrier question
Message-ID: <20100917231222.GA3060@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
 <3777.1284638136@redhat.com>
 <6383.1284647456@redhat.com>
 <20100916150356.GD2462@linux.vnet.ibm.com>
 <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu>
 <20100916163708.GG2462@linux.vnet.ibm.com>
 <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
 <1284656978.26423.11.camel@mulgrave.site>
 <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
 <1284760148.30449.107.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284760148.30449.107.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 07:49:08AM +1000, Benjamin Herrenschmidt wrote:
> 
> > Right but in the concrete namei example I can't see how a compiler
> > optimization can make a difference.  The order of the loads is quite
> > clear:
> > 
> >    LOAD inode = next.dentry->inode
> >    if (inode != NULL)
> >    	LOAD inode->f_op
> > 
> > What is there the compiler can optimize?
> 
> Those two loads depend on each other, I don't think any implementation
> can re-order them. In fact, such data dependency is typically what is
> used to avoid having barriers in some cases. The second load cannot be
> issued until the value from the first one is returned.

Sufficiently sadistic compiler and CPU implementations could do value
speculation, for example, driven by profile-feedback optimization.
Then the guess might initially incorrect, but then a store by some other
CPU could make the subsequent test decide (wrongly) that the guess had
in fact been correct.

Needless to say, I am not a fan of value speculation.  But other people
do like it a lot.

							Thanx, Paul
