Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0K3Oc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:32:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0K3Oc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:32:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20101124023238.GA26540@tiny>
References: <20101124023238.GA26540@tiny> <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com> <1290556456.2604.14.camel@localhost.localdomain>
To: kjhall@us.ibm.com, Serge Hallyn <serge.hallyn@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.5 3/5] key: add tpm_send command
Date: Tue, 30 Nov 2010 14:32:00 +0000
Message-ID: <19268.1291127520@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@canonical.com> wrote:

> > +int tpm_send(u32 chip_num, void *cmd, size_t buflen)
> 
> Hate to nit-pick, but any particular reason you're not following the
> rest of the file and using 'struct tpm_cmd_t *cmd' here?

Ummm...  Something else I've just noticed...

	static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
					       size_t bufsiz)

would suggest that buf is read-only, but tpm_transit() keeps casting it away,
and especially, casts it away before passing it to chip->vendor.recv()...
This would seem to indicate a logic error somewhere.

Certainly, tpm_atml_recv() modifies the buffer it is given to...

I suspect the argument and reply buffer pointers should be passed separately.

David
