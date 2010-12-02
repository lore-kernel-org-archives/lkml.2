Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0LBSPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:15:09 -0500
Received: from ist.d-labs.de ([213.239.218.44]:50422 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab0LBSPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:15:07 -0500
Date: Thu, 2 Dec 2010 19:14:12 +0100
From: Florian Mickler <florian@mickler.org>
To: Borislav Petkov <bp@amd64.org>
Newsgroups: gmane.linux.kernel
Cc: Tobias Karnat <tobias.karnat@googlemail.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101202191412.288b82f8@schatten.dmk.lab>
In-Reply-To: <20101202170610.GE27263@aftab>
References: <1291201307.3029.21.camel@Tobias-Karnat>
	<20101201123921.GA15530@a1.tnic>
	<1291209888.12511.11.camel@Tobias-Karnat>
	<20101201143329.GB18074@a1.tnic>
	<1291225614.8646.4.camel@Tobias-Karnat>
	<20101201193508.GA4916@liondog.tnic>
	<1291280613.10626.22.camel@Tobias-Karnat>
	<20101202152106.GA29301@a1.tnic>
	<1291306872.3898.7.camel@Tobias-Karnat>
	<20101202170610.GE27263@aftab>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010 18:06:10 +0100
Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Thu, 2 Dec 2010 17:48:35 +0100
> Subject: [PATCH] EDAC: Fix workqueue-related crashes
> 
> 00740c58541b6087d78418cebca1fcb86dc6077d changed edac_core to
> un-/register a workqueue item only if a lowlevel driver supplies a
> polling routine. Normally, when we remove a polling low-level driver,
> we go and teardown the workqueue and cancel all the queued work.
> However, the workqueue unreg happens based on the ->op_state setting,
> and edac_mc_del_mc() sets this to OP_OFFLINE _before_ we cancel the work
> item, leading to NULL ptr oops on the workqueue list.
> 
> Fix it by putting the unreg stuff in proper order.

Yes. That should work. Once we stopped the workqueue and removed it
from the global list, do we actually need to set it to OP_OFFLINE?

Also 00740c585 did fix a hang in edac_mc.c... could this also
happen in the edac_device_del_device/edac_pci_del_device functions? 

Regards,
Flo

