Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab0JFHoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:44:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:58739 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037Ab0JFHoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:44:20 -0400
Date: Wed, 6 Oct 2010 16:43:46 +0900
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de,
        hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk,
        bharrosh@panasas.com, joel.becker@oracle.com
Subject: Re: [RFC v2 05/21] tcm: Add ConfigFS subsystem backstore
	infrastructure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1286349730.5685.113.camel@haakon2.linux-iscsi.org>
References: <1286339442.5685.76.camel@haakon2.linux-iscsi.org>
	<20101006155833G.fujita.tomonori@lab.ntt.co.jp>
	<1286349730.5685.113.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101006163859Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 06 Oct 2010 16:43:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Oct 2010 00:22:10 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> > > The main issue here is that the user still needs to know the $LPORT_WWPN
> > > before hand (either from looking at a sticker on the card, or via
> > > another method) in order to preform the initial TFO->fabric_make_wwn()
> > > -> $TCM_MOD_make_wwn() operation.  So what we need is a configfs attrib
> > > at the top level TCM fabric group in order to see a list of the
> > > available hardware ports from the specific $TCM_MOD.  What I was
> > > thinking for TCM HW fabric module ports would be to have something like:
> > > 
> > > 	/sys/kernel/config/target/$TCM_MOD/hw_ports
> > > 
> > > that would walk the struct pci_dev looking for fabric module specific HW
> > > target mode capabilities.  I assume this is what you had in mind for
> > > drivers/scsi/ibmvscsi as well, yes..?
> > 
> > Doesn't sound so.
> > 
> > I want the driver to create necessary target directories in
> > /sys/kernel/config/target/ibmvscsit/ automatically.
> > 
> > 
> 
> Hmmmm, well configfs is entirely driven by userspace syscalls, so we

I think that we really want to configure things by kernel space too
because the scsi target stuff need to handle hardware.

Need to load the module and create the module name directory by name?

Need to read the content in sysfs to get the hardware info and create
the directories appropriate for the hardware by hand?

Looks strange and inconvenient interface to me. Why can't the kernel
just create the directory layout that suits to the hardware for users?


> want to try to avoid doing this (jlbec CC'ed).  We want userspace code
> to parse a list of these values from sysfs+configfs and use these
> individual HW WWPN value(s) as the directory/group names for the
> mkdir(2) mentioned above.
> 
> > And 'hw_ports' looks unnecessary because fc drivers already provide
> > such information under /sys/class/, I think.
> > --
> 
> Well, it really depends on what is required for individual target fabric
> modules I think, and perhaps could contain some other useful information
> about target mode HW specific available resources.  For the HW FC +
> libfc case, as long as the LLD continues to register TARGET_MODE capable
> HW ports in /sys/class, I think we should be good to go.
> 
> --nab
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
