Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab1FMKW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:22:56 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:45502 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1FMKWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:22:51 -0400
Subject: Re: [PATCH] unicore32: fix build error for find bitops
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        greg@kroah.com
In-Reply-To: <BANLkTim7znORJyhM2D9r7+p0CiYc+RL97Q@mail.gmail.com>
References: <1307617752-23426-1-git-send-email-gxt@mprc.pku.edu.cn>
	 <BANLkTikNC8uh-X_0iJZH3tYd_kf46W1Rwg@mail.gmail.com>
	 <BANLkTimWYjzxhQBH2A76D590KBfjKbguTA@mail.gmail.com>
	 <1307675815.1537.9.camel@epip-laptop>
	 <BANLkTi=aVFisCuS-W-4iNSmDVCtKOWD5_w@mail.gmail.com>
	 <1307955422.1878.3.camel@epip-laptop>
	 <BANLkTim7znORJyhM2D9r7+p0CiYc+RL97Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Mon, 13 Jun 2011 18:22:38 +0800
Message-ID: <1307960558.1878.21.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 18:33 +0900, Akinobu Mita wrote:
> 2011/6/13 Guan Xuetao <gxt@mprc.pku.edu.cn>:
> > Thanks, please review following patch:
> 
> Looks good to me.
Could I add your acked-by information on this patch?

> 
> > diff --git a/arch/unicore32/kernel/ksyms.c
> > b/arch/unicore32/kernel/ksyms.c
> > index a897080..d98bd81 100644
> > --- a/arch/unicore32/kernel/ksyms.c
> > +++ b/arch/unicore32/kernel/ksyms.c
> > @@ -24,8 +24,8 @@
> >
> >  #include "ksyms.h"
> >
> > -EXPORT_SYMBOL(__uc32_find_next_zero_bit);
> > -EXPORT_SYMBOL(__uc32_find_next_bit);
> > +EXPORT_SYMBOL(find_next_zero_bit);
> > +EXPORT_SYMBOL(find_next_bit);
> 
> I'm wondering why there are no EXPORT_SYMBOL for find_first_bit
> and find_first_zero_bit.
IMO, only functions that are needed by modules should be exported.
When building modules under unicore32 & pkunity-soc, we only need
find_next_bit and find_next_zero_bit exported at present, and if new
functions are required, I am going to add them in the same time.
In fact, I think, the 'arch-generic' ksyms.c is a better idea.

Guan Xuetao 


