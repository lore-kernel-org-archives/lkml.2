Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab0KKTtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:49:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0KKTtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:49:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com>
References: <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
Date: Thu, 11 Nov 2010 19:48:51 +0000
Message-ID: <6651.1289504931@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Reviewd-by: Mimi Zohar <zohar@watson.ibm.com>

You've missed an 'e'.

> +int tpm_send(u32 chip_num, char *cmd, int buflen)
> +{
> ...
> +	rc = transmit_cmd(chip, (struct tpm_cmd_t *)cmd, buflen,
> +			  "attempting tpm_cmd");

Make cmd 'void *' to obviate the cast.  Preferably it should be const too.

> +	module_put(chip->dev->driver->owner);

Where's the corresponding module_get()?  I suspect this should be wrapped to
match tpm_chip_find_get().

David
