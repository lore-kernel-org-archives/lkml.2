Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab2JXJtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:49:06 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:32888 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab2JXJtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:49:02 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15353004"
Message-ID: <1351072140.2237.135.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 05/10] xen/pvh: Extend vcpu_guest_context, p2m, event,
 and XenBus.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>
Date: Wed, 24 Oct 2012 10:49:00 +0100
In-Reply-To: <1351015931-16991-6-git-send-email-konrad.wilk@oracle.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
	 <1351015931-16991-6-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 19:12 +0100, Konrad Rzeszutek Wilk wrote:
[...]
> +		/* GUEST_GDTR_BASE and */
> +		ctxt->u.pvh.gdtaddr = (unsigned long)gdt;
> +		/* GUEST_GDTR_LIMIT in the VMCS. */
> +		ctxt->u.pvh.gdtsz = (unsigned long)(GDT_SIZE - 1);
> +
> [...]
> -		ctxt->gdt_frames[0] = gdt_mfn;
> -		ctxt->gdt_ents      = GDT_ENTRIES;
> +		ctxt->u.pv.gdt_frames[0] = gdt_mfn;
> +		ctxt->u.pv.gdt_ents      = GDT_ENTRIES;

I guess I've been told and forgotten but why does this need to differ
between PV and PVH? Can the hypervisor not take the gfn in gdt_frames[0]
= gdt_mfn and figure out the gdtaddr from it? Is this because n the PV
case the H/V loads the GDT with the address of its own mapping of the
gdt_frames but in the PVH case we have no such mapping because the
pagetables don't have a Xen region in them?

It's worthy of a comment in any case.

[...]
> +	/* PVH TBD/FIXME: future work */
[...]
> +		/* PVH: TBD/FIXME: debug and fix eio map to work with pvh */

Do we really need these TODOs inline in the code? Especially in generic
code.

Ian.

