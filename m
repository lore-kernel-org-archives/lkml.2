Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab1FPXoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 19:44:09 -0400
Received: from mail.perches.com ([173.55.12.10]:3054 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062Ab1FPXoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 19:44:07 -0400
Subject: Re: [PATCH 09/11] xen/xenbus: use printk_ratelimited() instead of
 printk_ratelimit()
From: Joe Perches <joe@perches.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
In-Reply-To: <4DFA6EF7.9060702@goop.org>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
	 <d2bc569719b3b1d8271d1f4b2c4080bbc7527e04.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
	 <4DFA6EF7.9060702@goop.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 16:44:05 -0700
Message-ID: <1308267845.12072.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 14:00 -0700, Jeremy Fitzhardinge wrote:
> On 06/16/2011 05:14 AM, Manuel Zerpies wrote:
> > Since printk_ratelimit() shouldn't be used anymore (see comment in
> > include/linux/printk.h), replace it with printk_ratelimited()
> Looks OK to me, but please fix the indentation of the rest of the
> statement to match.
[]
> > diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
[]
> > @@ -270,8 +271,7 @@ static void *xs_talkv(struct xenbus_transaction t,
> >  	}
> >  
> >  	if (msg.type != type) {
> > -		if (printk_ratelimit())
> > -			printk(KERN_WARNING
> > +		`printk_ratelimited(KERN_WARNING

Appears that it's not compile tested?
A stray "`" got put before printk_ratelimited()


