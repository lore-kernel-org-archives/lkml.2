Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab0KLWMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:12:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134Ab0KLWMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:12:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1289599613.4341.64.camel@localhost.localdomain>
References: <1289599613.4341.64.camel@localhost.localdomain> <1289514356.2726.18.camel@localhost.localdomain> <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <6651.1289504931@redhat.com> <22962.1289571072@redhat.com> <1289573330.4341.31.camel@localhost.localdomain> <4CDDB0A2.7090606@linux.vnet.ibm.com> 
To: David Safford <safford@watson.ibm.com>
Cc: dhowells@redhat.com, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
Date: Fri, 12 Nov 2010 22:11:39 +0000
Message-ID: <28655.1289599899@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Safford <safford@watson.ibm.com> wrote:

> David, does this look ok to you? If so, I will do two patches, one to
> fix the helper name throughout the existing tpm.c, and then a new
> version of the tpm_send patch which uses the new name.

I prefer my suggestion: Wrapping the module_put() up so that you don't see it
directly.  Then you don't need to alter tpm_chip_find_get().  I'll argue that
you don't need to know how tpm_chips are got/put, except in the code that
wraps it.

David
