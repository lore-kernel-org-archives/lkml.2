Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0EJMjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:39:47 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43513 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0EJMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:39:46 -0400
Date: Mon, 10 May 2010 21:39:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
       Ambresh <a0393775@ti.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [PATCHv4 1/4] procfs: Introduce socinfo under /proc
Message-ID: <20100510123902.GA15293@linux-sh.org>
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-3-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-2-git-send-email-eduardo.valentin@nokia.com> <20100510111259.GA14680@linux-sh.org> <20100510123514.GA11804@besouro.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510123514.GA11804@besouro.research.nokia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 03:35:14PM +0300, Eduardo Valentin wrote:
> On Mon, May 10, 2010 at 01:13:00PM +0200, ext Paul Mundt wrote:
> > On Mon, May 10, 2010 at 01:37:34PM +0300, Eduardo Valentin wrote:
> > > + */
> > > +#include <linux/fs.h>
> > > +#include <linux/init.h>
> > > +#include <linux/proc_fs.h>
> > > +#include <linux/seq_file.h>
> > > +
> > > +extern const struct seq_operations socinfo_op;
> > 
> > This doesn't look promising..
> 
> Right.. as stated in patch description (maybe not that clear), this was
> basically same thing which you see under fs/proc/cpuinfo.c
> 
The cpuinfo case is a bit more complex since you have actual real work to
do in the ->start op and you will iterate over the ->show op for each
CPU. In your socinfo case you're just following the single_xxx()
semantics so using those helpers there simplifies things quite a bit.

Architectures that do not support SMP technically employ single_open()
semantics, but the fs/proc/cpuinfo.c abstraction requires the
architecture to provide seq ops regardless.

Note that in the cpuinfo case there is often special handling for the
single (or boot CPU) case, such as printing out a descriptor for the
machine type and so on. You might be better off just extending cpuinfo
rather than introducing another /proc abstraction, presumably your
socinfo string will be fixed regardless of whether it's SMP or not.
