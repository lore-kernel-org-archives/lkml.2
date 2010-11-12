Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab0KLVYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:24:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab0KLVYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:24:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1289595738.2731.80.camel@localhost.localdomain>
References: <1289595738.2731.80.camel@localhost.localdomain> <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <26689.1289591135@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
Date: Fri, 12 Nov 2010 21:23:33 +0000
Message-ID: <27900.1289597013@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > Why do you allow the master key to be supplied by a user-defined key rather
> > than requiring a trusted-key unconditionally?
> 
> This is for systems without a TPM. The logic needs to exist, whether it
> is here or in EVM.  By doing it here, a user could provide a passphrase
> in the initramfs, which is used to decrypt the encrypted key.

I thought that might be the case.  In which case, it might be better to allow
someone to add a trusted key, supplying both encrypted and unencrypted
versions of the data so that the TPM need not be consulted.  You might want to
mark such a key so that it can be seen when it is dumped.

But if you're going to use a user-defined key, you really need to prefix the
description with something suitable.

David
