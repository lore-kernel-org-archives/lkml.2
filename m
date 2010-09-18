Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0IRXpC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 19:45:02 -0400
Received: from mail.perches.com ([173.55.12.10]:2102 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab0IRXpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 19:45:01 -0400
Subject: Re: [PATCH 01/25] arch/mips: Use static const char arrays
From: Joe Perches <joe@perches.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
In-Reply-To: <20100918225447.GA4739@linux-mips.org>
References: <cover.1284406638.git.joe@perches.com>
	 <8fcec0d2a48e806558e6bc39d5aa98518a97f8c7.1284406638.git.joe@perches.com>
	 <20100918225447.GA4739@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Sep 2010 16:44:59 -0700
Message-ID: <1284853499.1778.83.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-18 at 23:54 +0100, Ralf Baechle wrote:
> On Mon, Sep 13, 2010 at 12:47:39PM -0700, Joe Perches wrote:
> > diff --git a/arch/mips/pnx8550/common/reset.c b/arch/mips/pnx8550/common/reset.c
> > index fadd874..e0ac0b2 100644
> > --- a/arch/mips/pnx8550/common/reset.c
> > +++ b/arch/mips/pnx8550/common/reset.c
> > @@ -27,8 +27,8 @@
> >  
> >  void pnx8550_machine_restart(char *command)
> >  {
> > -	char head[] = "************* Machine restart *************";
> > -	char foot[] = "*******************************************";
> > +	static const char head[] = "************* Machine restart *************";
> > +	static const char foot[] = "*******************************************";
> >  
> >  	printk("\n\n");
> >  	printk("%s\n", head);
> NAK.
> The printks should have been taken out and shot.  And while at it line
> use the space on the other side of the wall for pnx8550_machine_power_off.

Fix them up as you see fit Ralf.

I don't have the hardware and was simply moving stuff
that should be const into const ro sections.

There are a lot of defects in that file, for instance
the printks don't use KERN_<level>.

cheers, Joe

