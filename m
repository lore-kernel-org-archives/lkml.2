Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0ISCro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 22:47:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:59006 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab0ISCrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 22:47:42 -0400
Subject: Re: memory barrier question
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: paulmck@linux.vnet.ibm.com
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <20100917231222.GA3060@linux.vnet.ibm.com>
References: <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
	 <3777.1284638136@redhat.com> <6383.1284647456@redhat.com>
	 <20100916150356.GD2462@linux.vnet.ibm.com>
	 <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu>
	 <20100916163708.GG2462@linux.vnet.ibm.com>
	 <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
	 <1284656978.26423.11.camel@mulgrave.site>
	 <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
	 <1284760148.30449.107.camel@pasglop>
	 <20100917231222.GA3060@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 12:47:01 +1000
Message-ID: <1284864421.30449.113.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 16:12 -0700, Paul E. McKenney wrote:
> On Sat, Sep 18, 2010 at 07:49:08AM +1000, Benjamin Herrenschmidt wrote:
> > 
> > > Right but in the concrete namei example I can't see how a compiler
> > > optimization can make a difference.  The order of the loads is quite
> > > clear:
> > > 
> > >    LOAD inode = next.dentry->inode
> > >    if (inode != NULL)
> > >    	LOAD inode->f_op
> > > 
> > > What is there the compiler can optimize?
> > 
> > Those two loads depend on each other, I don't think any implementation
> > can re-order them. In fact, such data dependency is typically what is
> > used to avoid having barriers in some cases. The second load cannot be
> > issued until the value from the first one is returned.
> 
> Sufficiently sadistic compiler and CPU implementations could do value
> speculation, for example, driven by profile-feedback optimization.
> Then the guess might initially incorrect, but then a store by some other
> CPU could make the subsequent test decide (wrongly) that the guess had
> in fact been correct.
> 
> Needless to say, I am not a fan of value speculation.  But other people
> do like it a lot.

Well, this verges on insanity... we get to a point where nobody's going
to get any code right :-)

I don't think the powerpc arch allows that, that leaves us with the
compiler, but so far I don't think gcc is -that- crazy. Those constructs
are common enough...

Cheers,
Ben.


