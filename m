Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0KPOJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:09:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab0KPOJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:09:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1289849751.3027.17.camel@localhost.localdomain>
References: <1289849751.3027.17.camel@localhost.localdomain> <1289694826.3257.82.camel@localhost.localdomain> <1289595738.2731.80.camel@localhost.localdomain> <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <26689.1289591135@redhat.com> <27900.1289597013@redhat.com> <8268.1289837934@redhat.com> 
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
Date: Tue, 16 Nov 2010 14:08:44 +0000
Message-ID: <23151.1289916524@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Am assuming you mean something like this:
> 
> keyctl add encrypted name "new trusted:master-key-name keylen" ring
> keyctl add encrypted name "new user:master-key-name keylen" ring
> 
> and, as you said, works without changing the API.

No, that's not what I mean.  I maeant that when your internal functions look
for the user key, they should preface the description with a prefix.

It should be handled in request_user_key() or request_master_key().  The
description given to request_trusted_key() should have the prefix applied
there.  There's no need to mention it at all in the encrypted key add_key
command line.

David
