Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0FHGSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:18:53 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12879 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0FHGSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:18:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=q90vW6TsdQaoS7+yT2JgMPJO+sYjOkev3R8o1Ml0HFAekJQhj521QwRbdubD3/JU3
	B0TNWfyHVHtrWOenAw0ZA==
Date: Mon, 7 Jun 2010 23:18:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic - two for the
 price of one - No thanks
In-Reply-To: <4C0DDAA6.8080002@panasas.com>
Message-ID: <alpine.DEB.2.00.1006072311170.31780@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
 <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DDAA6.8080002@panasas.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, Boaz Harrosh wrote:

> >> I already have my:
> >>  VERSION = 2
> >>  PATCHLEVEL = 6
> >>  SUBLEVEL = 35
> >> -EXTRAVERSION = -rc2
> >> +EXTRAVERSION = -rc2-my_tree
> >>
> > 
> > You shouldn't be using EXTRAVERSION for this purpose, you should be 
> > passing LOCALVERSION=my_tree to make.
> > 
> 
> That will not work because the way I run make is out of my control. Every
> one in the working group has his system. The Makefile is part of the
> public git tree, so every one will get the same identification without
> any confusion with Vanilla kernel, or what was compiled.
> 

If everyone using that tree wants the same version string for that kernel, 
use CONFIG_LOCALVERSION="-my_tree" in your .config and use "make 
LOCALVERSION=".

> > Unless it's a vanilla 2.6.35-rc2 kernel, it's inaccurate to persent it as 
> > 2.6.35-rc2; you'll need to pass LOCALVERSION to make to identify this as a 
> > non-vanilla kernel.
> 
> What are we lawyers? come on. And I do not have that problem! The output will
> not be 2.6.35-rc2 as you fear. It will be 2.6.35-rc2-my-tree-my-version.

That's because you're using EXTRAVERSION which is also used upstream to 
describe kernel releases (stable, rc, mm, etc).

> Please stop this *none-sense* this is not your place to mandate my Kernel name. If
> I'm forced to have an external Makefile I can just "mv" what ever name I choose.
> The Kernel name is an ABI you have just broken that, You must revert it ASAP.
> 

You still have the tools available to do everything you once did.
