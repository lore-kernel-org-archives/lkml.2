Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2ARM0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:26:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab2ARM0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:26:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALLzPKZFShWGxxic8zMfTxoj6Q+t7-sC90wp5J790VRmg-O09g@mail.gmail.com>
References: <CALLzPKZFShWGxxic8zMfTxoj6Q+t7-sC90wp5J790VRmg-O09g@mail.gmail.com> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184406.21874.65285.stgit@warthog.procyon.org.uk>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com
Subject: Re: [PATCH 08/21] KEYS: Add signature verification facility [ver #3]
Date: Wed, 18 Jan 2012 12:26:23 +0000
Message-ID: <26123.1326889583@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:

> It would also nice to have an API to supply pre-computed data hash.  For
> example IMA uses the same functionality to compute the hash of the file
> content, and then, based on security.ima type decided either verify it using
> just hash, or use digital signature.  We could pass a hash as data. But may
> be we do not want to have extra operation and compute hash over hash.

If I understand you correctly, you'd like to have the option to do the hashing
externally to this API?  Would you supply the completed hash or just a hash
with the data in it, and require this API to complete it (ie. chuck metadata
into it)?

I don't think it should be hard.  I could add an alternative to
verify_sig_add_data() perhaps.  Either that or one function that does the lot
and takes the precomputed hash as input.  There would be no need for the split
into four functions (begin, add_data, end, cancel) in such a case.  The reason
for the split is so that the caller can invoke add_data several times with
non-contiguous bits of data.

It might even make sense to expose the crypto hash object for direct access
rather than use add_data - but that then makes it hard to use crypto hardware
where you would just shovel the raw data into it and it does all the hashing
and cryptography in a black box.

David
