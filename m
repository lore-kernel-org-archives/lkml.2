Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab0KOPss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:48:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24188 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab0KOPsr (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 15 Nov 2010 10:48:47 -0500
Date: Mon, 15 Nov 2010 10:48:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Stephen Tweedie <sct@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/3] xen dom0: Add support for the platform_ops
 hypercall
Message-ID: <20101115154814.GB345@dumpdata.com>
References: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>
 <0aa82d86c699890ce3661927f176045fc8e47156.1289519130.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0aa82d86c699890ce3661927f176045fc8e47156.1289519130.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +typedef struct xenpf_settime xenpf_settime_t;
> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_settime_t);

We aren't using this..
> +typedef struct xenpf_add_memtype xenpf_add_memtype_t;
> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_add_memtype_t);

.. nor this..
> +typedef struct xenpf_del_memtype xenpf_del_memtype_t;
> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_del_memtype_t);

.. neither this one.
> +typedef struct xenpf_read_memtype xenpf_read_memtype_t;
> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_read_memtype_t);

..whoa, didn't know we had that many.
> +
> +#define XENPF_microcode_update    35
> +struct xenpf_microcode_update {
> +    /* IN variables. */
> +    GUEST_HANDLE(void) data;          /* Pointer to microcode data */
> +    uint32_t length;                  /* Length of microcode data. */
> +};
> +typedef struct xenpf_microcode_update xenpf_microcode_update_t;
> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_microcode_update_t);

OK, we are using this one.

.. snip .. 

Why not just introduce the one we are using (just one right now)
and on subsequent patches that enable the functionality add it in this file?
