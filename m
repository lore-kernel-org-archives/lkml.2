Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1FNVhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:37:31 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:36961 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab1FNVh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:37:29 -0400
Date: Tue, 14 Jun 2011 23:37:27 +0200
From: Tobias Diedrich <ranma+xen@tdiedrich.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: High amount of kernel "reserved" memory, about
 33% in 256MB DOMU [workaround included]
Message-ID: <20110614213727.GA23379@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma+xen@tdiedrich.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110613205003.GD20616@yumi.tdiedrich.de>
 <20110613215900.GB19117@dumpdata.com>
 <20110614001055.GB7417@yumi.tdiedrich.de>
 <20110614194810.GA26728@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614194810.GA26728@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Tue, Jun 14, 2011 at 02:10:55AM +0200, Tobias Diedrich wrote:
> > Konrad Rzeszutek Wilk wrote:
> > > On Mon, Jun 13, 2011 at 10:50:03PM +0200, Tobias Diedrich wrote:
> > > > Hi,
> > > > 
> > > > another issue I'm seeing with 3.0-rc2 and Xen is that there is an
> > > > unexpectedly high amount of kernel reserved memory.
> > > 
> > > > 
> > > > I suspect that Linux allocates page table entries and corresponding
> > > > data structures for the whole 6GB areas of the provided 'physical
> > > > RAM map' even though it has rather big unusable holes in it.
> > > 
> > > Can you run it with 'memblock=debug debug loglevel=8 initcall_debug'?
> > > It should tell you where it tries (and for much space) the pagetables.
> 
> Ugh. In the meantime I would suggest you do the combination of:
> 
> Xen hypervisor line: "dom0_mem=max:512M" and on the Linux line: "mem=512M" to
> cut down on the extra pagetable creation..

That helps a bit on dom0, for a 256MB dom0 it brings free memory up
from 142MB
|Memory: 145576k/6028224k available (6122k kernel code, 3932612k absent, 1950036k reserved, 4761k data, 576k init)
to 173MB
|Memory: 177156k/262144k available (6122k kernel code, 452k absent, 84536k reserved, 4761k data, 576k init)

To shrink it more maybe the acpi tables would have to be moved...

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
