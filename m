Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174Ab1D1Nne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:43:34 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:33744 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759500Ab1D1Nnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:43:32 -0400
Date: Thu, 28 Apr 2011 15:43:21 +0200
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, sliakh.lkml@gmail.com, jiang@cs.ncsu.edu,
        mingo@elte.hu
Subject: Re: Undoing module RONX protection fix
Message-ID: <20110428134321.GA10759@hal>
References: <20110418092348.GB7786@hal>
 <20110418092801.GC3837@infradead.org>
 <874o5v6drb.fsf@rustcorp.com.au>
 <20110421141949.GA10675@hal>
 <87ipu0l1kt.fsf@rustcorp.com.au>
 <1303985300.3495.93.camel@localhost.localdomain>
 <87tyditxo8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tyditxo8.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 09:06:39PM +0930, Rusty Russell wrote:
> On Thu, 28 Apr 2011 12:08:20 +0200, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> > How about this?
> > 
> > To be honest I don't like the inverse naming like in unset no-execute
> > too much, it makes me feel dizzy. But I wanted to keep the changes
> > minimal.
> 
> Yes, it should probably just be called protect_module_pages and
> unprotect_module_pages.  The current names provide far too much
> information.
> 
> But going back a bit, how did we end up with a NULL mod->module_init and
> yet module->init_text_size, mod->init_size or mod->init_ro_size
> non-zero?

printk'ing this reveals that mod->init_ro_size is not 0 but 0x1000.
Therefore the first page was modified.

Looks like init_ro_size is missing the reset to zero at the end of the init_module
syscall. Next patch ? ;-

> Because if start == end, set_page_attributes() is a noop, right?

Right.

> Confused,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
