Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1AZLTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:19:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1AZLTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:19:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1295887497-20198-6-git-send-email-roberto.sassu@polito.it>
References: <1295887497-20198-6-git-send-email-roberto.sassu@polito.it> <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Subject: Re: [RFC][PATCH v3 5/6] encrypted-keys: add ecryptfs format support
Date: Wed, 26 Jan 2011 11:18:45 +0000
Message-ID: <6520.1296040725@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Sassu <roberto.sassu@polito.it> wrote:

>  security/keys/keys_ecryptfs.c            |   81 ++++++++++++++++++++++++++++++
>  security/keys/keys_ecryptfs.h            |   30 +++++++++++

Can you rename these files please?  The 'keys' prefix is redundant.  They're
obviously about keys, or they shouldn't be in this directory.  I'd suggest
something like 'ecryptfs_format.[ch]'.

You might want to make a subdir here specifically for the trusted and
encrypted keys and all their formats and move those files into it if you're
going to have lots of formats.

>  /*
> + * valid_ecryptfs_desc - verify the description of a new/loaded encrypted key
> + *
> + * The description of a encrypted key with format 'ecryptfs' must contain
> + * exactly 16 hexadecimal characters.
> + *
> + */
> +static int valid_ecryptfs_desc(const char *ecryptfs_desc)
> +{

I think we need an additional key type operation - one that allows you to pass
judgement on the description to be given for a key in key_alloc().  On the
other hand, this doesn't help here as you can't do a full check on the key
description without the payload.

David
