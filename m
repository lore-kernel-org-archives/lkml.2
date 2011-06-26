Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1FZJn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 05:43:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43038 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1FZJnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 05:43:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=EE7QkNRd3tTIifkstlPn5O40N7cbwi8gdWLxjikJb7o2ss/BcLIiMdoM1CtSj+FwLc
         kPXHJ8iuKeouAM8OZGs+UYXVpHFMJ/IyY5QwP4pyxkVvdr2bs/AR8Dz+DnUzYNZVL6Y+
         9HLWMuaYAd9Zjiq61DQ3XRD7WgcI1+yNwZLWY=
Subject: Re: linux-next: Tree for June 24 (mtd + of)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Vitaly Wool <vwool@ru.mvista.com>
Date: Sun, 26 Jun 2011 12:43:41 +0300
In-Reply-To: <BANLkTi=Q-7bCHaH+-z6gnbwvexpGLYH6pA@mail.gmail.com>
References: <20110624155822.cb8cf6eb.sfr@canb.auug.org.au>
	 <20110624090456.191f1fda.randy.dunlap@oracle.com>
	 <1308947172.13493.37.camel@koala> <4E04F5D0.9090900@oracle.com>
	 <1308983721.23868.2.camel@koala>
	 <20110625152009.f264be78.randy.dunlap@oracle.com>
	 <BANLkTi=Q-7bCHaH+-z6gnbwvexpGLYH6pA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1309081426.6618.0.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-26 at 00:11 -0600, Grant Likely wrote:
> > 3.0-rc4 does not have this build error when I use the .config file with it...
> > however, I think that 3.0-rc4 also does not build ofpart.ko as it should.
> >
> > Looks to me like changes in drivers/mtd/{Kconfig && Makefile} caused this
> > build error.
> 
> The following commit in linux-next appears to be the culprit:
> 
> commit 1a6bc893044b961caae1c5a9c6c2065e608da427
> Author: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Date:   Sun May 29 21:32:33 2011 +0400
> 
>     mtd: prepare to convert of_mtd_parse_partitions to partition parser
> 
>     Prepare to convert of_mtd_parse_partitions() to usual partitions parser:
>     1) Register ofpart parser
>     2) Internally don't use passed device for error printing
>     3) Add device_node to mtd_part_parser_data struct
>     4) Move of_mtd_parse_partitions from __devinit to common text section
>     5) add ofpart to the default list of partition parsers
> 
>     Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>     Signed-off-by: Artem Bityutskiy <dedekind1@gmail.com>
> 
> It adds a module_init() call to ofpart.c which does not work the way
> that ofpart.c is linked to mtdcore.o.  Seems like that commit series
> still needs work.

OK, let's ask Dmitry to take a look at this.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

