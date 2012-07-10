Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2GJPhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:37:51 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:36410 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab2GJPht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:37:49 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr387qFmLE
X-RZG-CLASS-ID: mo00
Date: Tue, 10 Jul 2012 17:37:47 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Daniel Kiper <dkiper@net-space.pl>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120710153747.GA1731@aepfle.de>
References: <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
 <20120706133105.GA20600@aepfle.de>
 <20120706141419.GA21951@aepfle.de>
 <4FF7174C020000780008E1FF@nat28.tlf.novell.com>
 <20120706172918.GA15222@aepfle.de>
 <20120710093327.GA13864@aepfle.de>
 <20120710141411.GB1791@phenom.dumpdata.com>
 <1341931594.8586.44.camel@hastur.hellion.org.uk>
 <20120710145110.GA15218@phenom.dumpdata.com>
 <1341934149.8586.45.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1341934149.8586.45.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, Ian Campbell wrote:

> On Tue, 2012-07-10 at 10:51 -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, Jul 10, 2012 at 08:46:34AM -0600, Ian Campbell wrote:
> > > On Tue, 2012-07-10 at 10:14 -0400, Konrad Rzeszutek Wilk wrote:
> > > > Which brings me to another question - say we do use this patch, what
> > > > if the decompressor overwrites the old kernels .data section. Won't
> > > > we run into this problem again?
> > > 
> > > I've not really been following this thread that closely but wouldn't the
> > > right answer be for the original kernel to unmap the shared info on
> > > kexec? Or maybe remap it up to some high/reserved address? Can it read
> > 
> > That would be the right answer I think, but I don't see the a VCPU_deregister
> > call (only VCPU_register).
> 
> Is the issue here vcpuinfo or the shared info (or both)?

shared info is the issue in PVonHVM.

Olaf
