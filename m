Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0F2Prv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:47:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587Ab0F2Prs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:47:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C29674C.9070503@gmail.com>
References: <4C29674C.9070503@gmail.com> <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not used
Date: Tue, 29 Jun 2010 16:47:41 +0100
Message-ID: <22319.1277826461@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock@gmail.com> wrote:

> +	if (fn) {
> + 			printk(KERN_WARNING "dev%d: Failed to create
> firmware_node: %d\n", status, fn);
> +	}else if (pn) {
> +			printk(KERN_WARNING "dev%d: Failed to create
> physical_node: %d\n", status, pn);
> + 			return 0;
> +		}

The if-statement should be correctly indented (it's inside another
if-body, so needs to be one more tab over) and there needs to be a space
before the else.

You should probably split your printks up so they don't exceed 80 chars too,
for example:

			printk(KERN_WARNING
			       "dev%d: Failed to create physical_node: %d\n",
			       status, pn);

Also 'status' is probably the wrong thing to print as the number in "dev%d".
If it worked, that should be unconditionally AE_OK, I think.  Can you not use
dev_warn() or similar instead or printk?

David
