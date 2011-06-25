Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1FYWUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 18:20:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47871 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1FYWUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 18:20:42 -0400
Date: Sat, 25 Jun 2011 15:20:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: dedekind1@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Vitaly Wool <vwool@ru.mvista.com>
Subject: Re: linux-next: Tree for June 24 (mtd + of)
Message-Id: <20110625152009.f264be78.randy.dunlap@oracle.com>
In-Reply-To: <1308983721.23868.2.camel@koala>
References: <20110624155822.cb8cf6eb.sfr@canb.auug.org.au>
	<20110624090456.191f1fda.randy.dunlap@oracle.com>
	<1308947172.13493.37.camel@koala>
	<4E04F5D0.9090900@oracle.com>
	<1308983721.23868.2.camel@koala>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E065F28.0094:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jun 2011 09:35:13 +0300 Artem Bityutskiy wrote:

> On Fri, 2011-06-24 at 13:38 -0700, Randy Dunlap wrote:
> > On 06/24/11 13:26, Artem Bityutskiy wrote:
> > > On Fri, 2011-06-24 at 09:04 -0700, Randy Dunlap wrote:
> > >> On Fri, 24 Jun 2011 15:58:22 +1000 Stephen Rothwell wrote:
> > >>
> > >>> Hi all,
> > >>>
> > >>> Changes since 20110623:
> > >>>
> > >>> My fixes tree includes:
> > >>> 	(as an experiment) the early part of mmotm-2011-06-22-13-05
> > >>> 	STAGING: Comedi: Build only on arches providing PAGE_KERNEL_NOCACHE
> > >>
> > >>
> > >> When CONFIG_MTD=m, CONFIG_MTD_OF_PARTS=y:
> > >>
> > >> drivers/mtd/ofpart.o: In function `init_module':
> > >> ofpart.c:(.init.text+0x0): multiple definition of `init_module'
> > >> drivers/mtd/mtdcore.o:(.init.text+0x43): first defined here
> > > 
> > > I guess this is some old issue? I do not think ofpart can be compiled-in
> > > if the mtd core is a module...
> > 
> > [adding driver author, Vitaly]
> > 
> > No, it's a current issue.
> 
> I meant that the subject suggests this is about linux-next, but this
> problem should be in upstream.

Sorry I misunderstood your comment.

3.0-rc4 does not have this build error when I use the .config file with it...
however, I think that 3.0-rc4 also does not build ofpart.ko as it should.

Looks to me like changes in drivers/mtd/{Kconfig && Makefile} caused this
build error.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
