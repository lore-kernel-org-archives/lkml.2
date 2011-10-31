Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab1JaJtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:49:50 -0400
Received: from ozlabs.org ([203.10.76.45]:45649 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221Ab1JaJtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:49:49 -0400
From: Michael Neuling <mikey@neuling.org>
To: Santosh Kumar <santoshkumar.a@gmail.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Tony Breeds <tony@bakeyournoodle.com>,
        Ian Munsie <ianmunsi@au1.ibm.com>
Subject: Re: powerpc 476, Little-endian, pte fault
In-reply-to: <CAJw04pAh5QDQMkUHbj9=rRPiUCZejimHiydCJFMAoZeSd_ydhA@mail.gmail.com>
References: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com> <12144.1320040276@neuling.org> <CAJw04pAh5QDQMkUHbj9=rRPiUCZejimHiydCJFMAoZeSd_ydhA@mail.gmail.com>
Comments: In-reply-to Santosh Kumar <santoshkumar.a@gmail.com>
   message dated "Mon, 31 Oct 2011 12:05:28 +0530."
Date: Mon, 31 Oct 2011 20:49:48 +1100
Message-ID: <20440.1320054588@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have built a cross compiler for ppc440 in little endian mode and
> using it to build the kernel.
> 
> Yes i am running Linux in Little-Endian. This is the first user space
> process. I wrote the below program and running it as init from
> /sbin/init. I have also set the permissions with chmod +s.
> 
> main()
> {
> 
> while(1){
> printf("hello world");
> sleep(1);
>  }
> }

Does libc even support little endian on PPC?

> I have attached the patch.

This is a pretty huge patch:

 115 files changed, 44479 insertions(+), 7398 deletions(-)

It seems to include a new platform as well as a bunch of unrelated junk.

I suggest you need to break this down into something more digestible.
Like remove all the junk in the patch.  Then add the support for the new
platform (invader? platform).  Then start looking at little endian.
Unless you do this, it's unlikely anyone here is going to be able to
help.

When you get to the little endian work, you might want to take a look at
this patch series from Ian Munsie:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-October/086165.html

Mikey
