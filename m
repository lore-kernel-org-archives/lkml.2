Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab2IEVMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:12:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:52812 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759287Ab2IEVMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:12:10 -0400
Message-ID: <1346879505.19098.3.camel@pasglop>
Subject: Re: [PATCH V3 1/3] drivers/char/tpm: Add new device driver to
 support IBM vTPM
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Ashley Lai <adlai@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, adlai@us.ibm.com
Date: Thu, 06 Sep 2012 07:11:45 +1000
In-Reply-To: <20120905154644.GA14925@linux.vnet.ibm.com>
References: <1344987282.4430.26.camel@footlong>
	 <1345670263.25124.7.camel@footlong>
	 <20120822214217.GB13519@linux.vnet.ibm.com>
	 <1346816407.2257.37.camel@pasglop>
	 <20120905154644.GA14925@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 10:46 -0500, Kent Yoder wrote:
> On Wed, Sep 05, 2012 at 01:40:07PM +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2012-08-22 at 16:42 -0500, Kent Yoder wrote:
> > > On Wed, Aug 22, 2012 at 04:17:43PM -0500, Ashley Lai wrote:
> > > > This patch adds a new device driver to support IBM virtual TPM
> > > > (vTPM) for PPC64.  IBM vTPM is supported through the adjunct
> > > > partition with firmware release 740 or higher.  With vTPM
> > > > support, each lpar is able to have its own vTPM without the
> > > > physical TPM hardware.
> > > > 
> > > > This driver provides TPM functionalities by communicating with
> > > > the vTPM adjunct partition through Hypervisor calls (Hcalls)
> > > > and Command/Response Queue (CRQ) commands.
> > > 
> > >  Thanks Ashley, I'll include this in my next pull request to James.
> > 
> > Oh ? I was about to put it in the powerpc tree ... But yeah, I notice
> > there's a change to tpm.h so it probably should be at least acked by the
> > TPM folks. As for the subsequent patches, they are powerpc specific so I
> > can add them, I don't think there's a strict dependency, is there ?
> 
>   James did accept my pull request, so these are already in
> security-next...

For the driver itself, it's not a big issue (though I did found issue
while reviewing it so it will need another round of updates). For the
code that changes arch/powerpc, especially prom_init.c, that stuff must
at the very least be acked by me (or the acting powerpc person if I'm
away) if it's going to go via a different tree.

Cheers,
Ben.

