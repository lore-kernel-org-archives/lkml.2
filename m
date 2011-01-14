Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab1ANNcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:32:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1ANNcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:32:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
To: Jesper Juhl <jj@chaosbits.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, David Safford <safford@us.ibm.com>,
        James Morris <jmorris@namei.org>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Trusted and Encrypted Keys: fix up TSS_rawhmac() so we always kfree() and remember to call va_end()
Date: Fri, 14 Jan 2011 13:31:55 +0000
Message-ID: <3820.1295011915@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl <jj@chaosbits.net> wrote:

> In security/keys/trusted_defined.c::TSS_rawhmac() we may leak the storage 
> allocated to 'sdesc' if
>   data = va_arg(argp, unsigned char *);
> results in a NULL 'data' and we then leave the function by returning 
> -EINVAL. We also neglect calling va_end(argp) in that case and furthermore 
> we neglect va_end(argp) if
>   ret = crypto_shash_update(&sdesc->shash, data, dlen);
> results in ret being negative and we then jump to the 'out' label.
> 
> I believe this patch takes care of these issues. Please review and 
> consider for inclusion.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: David Howells <dhowells@redhat.com>
