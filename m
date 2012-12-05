Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2LEMhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:37:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab2LEMhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:37:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <s5hobi9aqxs.wl%tiwai@suse.de>
References: <s5hobi9aqxs.wl%tiwai@suse.de> <1354616321-13520-2-git-send-email-mmarek@suse.cz> <1354616321-13520-1-git-send-email-mmarek@suse.cz> <22396.1354645048@warthog.procyon.org.uk> <87hao1gyiv.fsf@rustcorp.com.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: dhowells@redhat.com, Rusty Russell <rusty@ozlabs.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 2/3] MODSIGN: Avoid using .incbin in C source
Date: Wed, 05 Dec 2012 12:35:42 +0000
Message-ID: <10107.1354710942@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH v2] MODSIGN: Avoid using .incbin in C source
> 
> Using the asm .incbin statement in C sources breaks any gcc wrapper which
> assumes that preprocessed C source is self-contained. Use a separate .S
> file to include the siging key and certificate.
> 
> Tested-by: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Acked-by: David Howells <dhowells@redhat.com>

> +#define GLOBAL(name)	\
> +	.globl ASM_SYMBOL(name);	\
> +	ASM_SYMBOL(name):

This should perhaps be moved into a global header.
