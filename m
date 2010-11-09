Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0KIGk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 01:40:27 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:48040 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab0KIGk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 01:40:26 -0500
Date: Mon, 8 Nov 2010 23:40:16 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: David Safford <safford@watson.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.2 3/4] keys: add new trusted key-type
Message-ID: <20101109064016.GF16307@obsidianresearch.com>
References: <1289230246-3856-1-git-send-email-zohar@linux.vnet.ibm.com> <1289230246-3856-4-git-send-email-zohar@linux.vnet.ibm.com> <20101108170937.GA31501@obsidianresearch.com> <1289240313.6060.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289240313.6060.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 01:18:33PM -0500, David Safford wrote:

> This is strictly for convenience in initramfs, so that the trusted
> key can be loaded and locked in a single command, with no need for
> an additional application to extend a PCR. As the the TPM driver 
> already has support for extend, it's a trivial addition.

I guess I imagined that user space would want to extend some PCRs
anyhow with data from the root filesystem before handing over
control. This is not related to your patch at all, just overall how
I'd expect the TPM to be used..

It just seems like really odd functionality. I'm not familiar with the
KH api, but is there any chance now (or in future) that non-root could
access this function?

A few random observations
 - I'm sure someone will say kdoc format should be used for those
   function comments?
 - Using a random value to extend the PCR effectively wastes it
   and creates a tiny risk the random extend could result in 0.
 - It would be nice to formally state the datablob is a
   TPM_STORED_DATA with no embellishments. The expectation is
   userspace can validate the sealInfo prior to loading the
   key.
 - I'm unclear on the merits of using raw random data from the TPM.
   I'd feel much better if this was mixed with random
   from the kernel pool too. Ideally using a FIPS DBRNG transform..
 - Shouldn't all the TPM RPC functions live together in the TPM code
   someplace? You've done a good job of adding many more general
   primitives to build RPC's with.

   FWIW, last time I worked with TPMs I built a RPC code generator
   for this stuff, which if any more are added would be a really smart
   direction to head in.

Cheers,
Jason
