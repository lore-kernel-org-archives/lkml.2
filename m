Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab1JRRn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:43:59 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33334 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662Ab1JRRn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:43:58 -0400
Date: Tue, 18 Oct 2011 19:43:53 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: don't put module.h into irq.h for tracking irqgen
 modules.
Message-ID: <20111018174353.GB16894@breakpoint.cc>
References: <1317434037-15343-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317434037-15343-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 09:53:57PM -0400, Paul Gortmaker wrote:
> Recent commit "irq: Track the owner of irq descriptor" in
> commit ID b6873807a7143b7 placed module.h into linux/irq.h
> but we are trying to limit module.h inclusion to just C files
> that really need it, due to its size and number of children
> includes.  This targets just reversing that include.

Sorry for that. This is for "not to re-compile the whole tree once a tiny
header file has changes" right?

> Add in the basic "struct module" since that is all we really need
> to ensure things compile.  In theory, b687380 should have added the
> module.h include to the irqdesc.h header as well, but the implicit
> module.h everywhere presence masked this from showing up.  So give
> it the "struct module" as well.
> 
> As for the C files, irqdesc.c is only using THIS_MODULE, so it
> does not need module.h - give it export.h instead.  The C file

just tried to compile this ontop of the tip tree and it ended with:
|kernel/irq/irqdesc.c:12:26: fatal error: linux/export.h: No such file or directory

I guess your tree provides that file.

> irq/manage.c is now (as of b687380) using try_module_get and
> module_put and so it needs module.h (which it already has).
> 
> Also convert the irq_alloc_descs variants to macros, since all
> they really do is is call the __irq_alloc_descs primitive.
> This avoids including export.h and no debug info is lost.

macros, I see. THIS_MODULE is quite simple. What about moving this part from
module.h which is hidden behind ifdef MODULE and make it avaiable as a separate
headerfile with no children?

Sebastian
