Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1GBQrm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:47:42 -0400
Received: from mail.southpole.se ([193.12.106.18]:41139 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1GBQrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:47:40 -0400
Subject: Re: [PATCH 1/2] asm-generic: add MMU variants of io.h functions
From: Jonas Bonn <jonas@southpole.se>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        liqin.chen@sunplusct.com, gxt@mprc.pku.edu.cn
In-Reply-To: <CAMjpGUfZwZu-ZCJj2cmq1w6B71-gQ8G27FpYdhseyq3hoZRL+Q@mail.gmail.com>
References: <1309622006-28343-1-git-send-email-jonas@southpole.se>
	 <CAMjpGUfZwZu-ZCJj2cmq1w6B71-gQ8G27FpYdhseyq3hoZRL+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Sat, 02 Jul 2011 18:47:30 +0200
Message-ID: <1309625250.24186.1224.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2011-07-02 at 12:38 -0400, Mike Frysinger wrote:
> On Sat, Jul 2, 2011 at 11:53, Jonas Bonn wrote:
> > Some of the implementations, in particular the ioremap variants, in
> > asm-generic/io.h are for systems with an MMU.
> 
> do you mean "without an MMU" ?

Yes, of course... that's supposed to be _without_ an MMU.

> 
> > +#ifdef CONFIG_MMU
> > +#define xlate_dev_mem_ptr(p)   __va(p)
> > +#else
> >  #define xlate_dev_mem_ptr(p)   ((void *) (p))
> > +#endif
> 
> i wonder if we could do:
> #ifndef __va
> #define __va(p) ((void *)(p))
> #endif
> #define xlate_dev_mem_ptr(p)   __va(p)
> -mike

This seems to introduce an artificial definition of a "virtual" address
for systems without an MMU, which strikes me as a bit odd.  If this is
what people prefer, that's fine... I think I prefer the former variant,
though.

/Jonas

