Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373Ab1JaLX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 07:23:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:47426 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932704Ab1JaLXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 07:23:55 -0400
Subject: Re: powerpc 476, Little-endian, pte fault
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Santosh Kumar <santoshkumar.a@gmail.com>, linuxppc-dev@ozlabs.org,
        Ian Munsie <ianmunsi@au1.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20440.1320054588@neuling.org>
References: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
	 <12144.1320040276@neuling.org>
	 <CAJw04pAh5QDQMkUHbj9=rRPiUCZejimHiydCJFMAoZeSd_ydhA@mail.gmail.com>
	 <20440.1320054588@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 12:23:34 +0100
Message-ID: <1320060214.30202.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 20:49 +1100, Michael Neuling wrote:
> > I have built a cross compiler for ppc440 in little endian mode and
> > using it to build the kernel.
> > 
> > Yes i am running Linux in Little-Endian. This is the first user space
> > process. I wrote the below program and running it as init from
> > /sbin/init. I have also set the permissions with chmod +s.
> > 
> > main()
> > {
> > 
> > while(1){
> > printf("hello world");
> > sleep(1);
> >  }
> > }
> 
> Does libc even support little endian on PPC?

Ian did a port a while back for uClibc, is that at least partially based
on it ?

> > I have attached the patch.
> 
> This is a pretty huge patch:
> 
>  115 files changed, 44479 insertions(+), 7398 deletions(-)
> 
> It seems to include a new platform as well as a bunch of unrelated junk.
>
> I suggest you need to break this down into something more digestible.
> Like remove all the junk in the patch.  Then add the support for the new
> platform (invader? platform).  Then start looking at little endian.
> Unless you do this, it's unlikely anyone here is going to be able to
> help.
>
> When you get to the little endian work, you might want to take a look at
> this patch series from Ian Munsie:
> 
> http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-October/086165.html

Right, the new patch should be if possible based on Ian's series or at
least a cleaned / rebased variant of it. Then split in bits so we can
review it properly.

Cheers,
Ben.

> Mikey
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


