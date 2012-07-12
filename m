Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161508Ab2GLRoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:44:15 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:25526 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161495Ab2GLRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:44:14 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGjS0PFkFT
X-RZG-CLASS-ID: mo00
Date: Thu, 12 Jul 2012 19:44:11 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen pv-on-hvm: add pfn_is_ram helper for
 kdump
Message-ID: <20120712174411.GA24313@aepfle.de>
References: <1342113639-19728-1-git-send-email-olaf@aepfle.de>
 <20120712172424.GA5895@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120712172424.GA5895@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, Konrad Rzeszutek Wilk wrote:

> > +++ b/include/xen/interface/hvm/hvm_op.h
> > @@ -43,4 +43,24 @@ struct xen_hvm_pagetable_dying {
> >  typedef struct xen_hvm_pagetable_dying xen_hvm_pagetable_dying_t;
> >  DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_pagetable_dying_t);
> >   
> > +typedef enum {
> > +    HVMMEM_ram_rw,             /* Normal read/write guest RAM */
> > +    HVMMEM_ram_ro,             /* Read-only; writes are discarded */
> > +    HVMMEM_mmio_dm,            /* Reads and write go to the device model */
> > +} hvmmem_type_t;
> 
> Does this have to be a typdef?
> 
> > +
> > +#define HVMOP_get_mem_type    15
> > +/* Return hvmmem_type_t for the specified pfn. */
> > +struct xen_hvm_get_mem_type {
> > +    /* Domain to be queried. */
> > +    domid_t domid;
> > +    /* OUT variable. */
> > +    uint16_t mem_type;
> > +    uint16_t pad[2]; /* align next field on 8-byte boundary */
> > +    /* IN variable. */
> > +    uint64_t pfn;
> > +};
> > +typedef struct xen_hvm_get_mem_type xen_hvm_get_mem_type_t;
> 
> Please no typdefs. I can fix this up, but in the future pls don't add
> more of them.

Its just a forward port from what went into linux-2.6.18.


Olaf
