Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab0F1Msq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0F1Msp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:48:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277621246-10960-4-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, sds@tycho.nsa.gov,
       lenb@kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not used
Date: Mon, 28 Jun 2010 13:48:13 +0100
Message-ID: <7214.1277729293@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock@gmail.com> wrote:

> +		if (ret) {
> +			printk(KERN_WARNING "dev%d: Failed to get exception\n", ret);
> +		}

That's not a good warning because it's a meaningless string and you're passing
the error number to the dev%d.

Better would perhaps be:

	"dev%d: Failed to create physical_node sysfs link: %d\n"

Note also that you're only checking the result of one sysfs_create_link().
You should probably check both.

Also you're introducing a pair of unnecessary braces as there's only one
statement in the if-body.

David
