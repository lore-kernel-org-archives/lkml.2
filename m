Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab2GJO7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:59:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25225 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab2GJO7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:59:48 -0400
Date: Tue, 10 Jul 2012 10:51:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Olaf Hering <olaf@aepfle.de>, Daniel Kiper <dkiper@net-space.pl>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120710145110.GA15218@phenom.dumpdata.com>
References: <20120706084120.GA31219@router-fw-old.local.net-space.pl>
 <20120706120750.GA8970@aepfle.de>
 <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
 <20120706133105.GA20600@aepfle.de>
 <20120706141419.GA21951@aepfle.de>
 <4FF7174C020000780008E1FF@nat28.tlf.novell.com>
 <20120706172918.GA15222@aepfle.de>
 <20120710093327.GA13864@aepfle.de>
 <20120710141411.GB1791@phenom.dumpdata.com>
 <1341931594.8586.44.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341931594.8586.44.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 08:46:34AM -0600, Ian Campbell wrote:
> On Tue, 2012-07-10 at 10:14 -0400, Konrad Rzeszutek Wilk wrote:
> > Which brings me to another question - say we do use this patch, what
> > if the decompressor overwrites the old kernels .data section. Won't
> > we run into this problem again?
> 
> I've not really been following this thread that closely but wouldn't the
> right answer be for the original kernel to unmap the shared info on
> kexec? Or maybe remap it up to some high/reserved address? Can it read

That would be the right answer I think, but I don't see the a VCPU_deregister
call (only VCPU_register).

But perhaps the XENMEM_decrease_reservation for the particular MFN is the
answer to do a VCPU "de-register" ?

> the original address used by hvmloader at start of day and reuse that?

Wait, we can map multiple shared_info? Ooh, somehow I thought the guest
could only do one registration.

> 
> Ian.
> 
