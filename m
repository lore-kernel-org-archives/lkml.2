Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab1GTJ2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 05:28:55 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:39654 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1GTJ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 05:28:53 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20110719150423.GA7001@redhat.com>
References: <20110714180528.GF6672@redhat.com>
	 <1310739717.10789.31.camel@br98xy6r> <20110715143820.GG3428@redhat.com>
	 <1310744603.10789.79.camel@br98xy6r> <20110718123140.GB31986@redhat.com>
	 <1310997641.4427.10.camel@br98xy6r> <20110718141943.GE31986@redhat.com>
	 <1311000253.4427.23.camel@br98xy6r> <20110718152532.GF31986@redhat.com>
	 <1311012188.4427.58.camel@br98xy6r>  <20110719150423.GA7001@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 20 Jul 2011 11:28:35 +0200
Message-ID: <1311154115.3829.17.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Tue, 2011-07-19 at 11:04 -0400, Vivek Goyal wrote:
> On Mon, Jul 18, 2011 at 08:03:08PM +0200, Michael Holzheu wrote:

[snip]
 
> > To allow the stand-alone dump tools as kdump triggers, we then only
> > would have to provide an s390 specific way to tell the stand-alone dump
> > tools:
> > 1. Entry point address into purgatory
> > 2. Address, size and checksum for purgatory
> > 
> > We could store address, size and checksum of the purgatory to a fixed
> > offset in the kdump kernel image. This can be done in the kexec tools
> > code.
> 
> I think this will require kernel changes also? Otherwise how would you
> store variables in kernel address space.

We can store purgatory address, size and checksum in the kernel image
from kexec tools user space as we do it currently for the initrd.

[snip]

> > What you as kdump framework maintainer would have to accept with this
> > solution is that it is allowed now to start kdump directly via purgatory
> > without using code from the old kernel (e.g. crash_kexec). This has as
> > implication that all things that the old kernel has to initialize for
> > kdump has to be done before the system crashes. Currently this is only
> > the initialization of vmcoreinfo.
> 
> when would you save vmcoreinfo? I guess I shall have to look at the
> patches.

patch #4: We have to save vmcoreinfo at startup time of the production
kernel.

Perhaps it would be best to send you a new patch series with our latest
proposal.

Michael


