Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0FGTp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:45:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45316 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab0FGTpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:45:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=dKp5K0lqfypIES99g7fZqQ5Coqy5zBOZ+BIywdkxBPtJYQ7qzFPtalmGHaeboVVf/
	Pg+Go/M60cOi8+nBPY2Fw==
Date: Mon, 7 Jun 2010 12:45:14 -0700 (PDT)
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
In-Reply-To: <4C0D29DE.6050602@panasas.com>
Message-ID: <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
 <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010, Boaz Harrosh wrote:

> Rrrr. If I wanted CONFIG_LOCALVERSION_AUTO, I would use that one. At least
> it is actually useful and informative.
> 
> I already have my:
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 35
> -EXTRAVERSION = -rc2
> +EXTRAVERSION = -rc2-my_tree
> 

You shouldn't be using EXTRAVERSION for this purpose, you should be 
passing LOCALVERSION=my_tree to make.

> Which is managed by a git tree (for everybody based on my tree)
> 
> At least give us a way out with:
> CONFIG_LOCALVERSION_NO_AUTO_IM_REALLY_STUPID=y way out.
> 
> or EXTRAVERSION != $(git version)
> 
> But don't leave us cold in the woods like that. (What if I remove the git tree altogether, move to svn)
> 
> If I can shoot my self in the foot, it does not mean Government should not issue any more
> gun licenses.
> 
> I already have my outer Makefile system that makes sure I don't forget to compile, or
> "did I install this Kernel or not". Please let us have a way out?
> 

Unless it's a vanilla 2.6.35-rc2 kernel, it's inaccurate to persent it as 
2.6.35-rc2; you'll need to pass LOCALVERSION to make to identify this as a 
non-vanilla kernel.
