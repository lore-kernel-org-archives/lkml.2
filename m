Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1FJWfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:35:52 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36628 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758126Ab1FJWfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:35:50 -0400
X-Sasl-enc: 7TmhSelS7OfcXF9klLWFLo1+yRIre73ScAhUNO4K8Oz8 1307745349
Date: Fri, 10 Jun 2011 15:34:23 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 related)
Message-ID: <20110610223423.GB15868@kroah.com>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
 <20110609184127.GA2760@kroah.com>
 <20110609192243.GA3980@kroah.com>
 <20110610160548.529797c7.sfr@canb.auug.org.au>
 <20110610160938.cd01c408.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610160938.cd01c408.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 04:09:38PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Fri, 10 Jun 2011 16:05:48 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > No, I still get these:
> > 
> > In file included from drivers/staging/comedi/drivers/addi_apci_035.c:7:0:
> > drivers/staging/comedi/drivers/addi-data/addi_common.c: In function 'i_ADDI_Attach':
> > drivers/staging/comedi/drivers/addi-data/addi_common.c:2765:7: error: implicit declaration of function 'virt_to_bus'
> > 
> > virt_to_bus is only defined for 32 bit powerpc (not 64 bit) (and maybe
> > not at all on some architectures e.g. sparc).
> > 
> > From Documentation/DMA-API-HOWTO.txt:
> > "All drivers should be using these interfaces with no exceptions.  It
> > is planned to completely remove virt_to_bus() and bus_to_virt() as
> > they are entirely deprecated.  Some ports already do not provide these
> > as it is impossible to correctly support them."
> 
> Drivers that use virt_to_bus should Kconfig depend on VIRT_TO_BUS.

Ah, I missed that, sorry.  I'll go make that change as well.

greg k-h
