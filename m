Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0KXO7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:59:40 -0500
Received: from adelie.canonical.com ([91.189.90.139]:46991 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab0KXO7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:59:38 -0500
Date: Wed, 24 Nov 2010 08:59:25 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: David Safford <safford@watson.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.5 3/5] key: add tpm_send command
Message-ID: <20101124145925.GA2203@tiny>
References: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1290556456.2604.14.camel@localhost.localdomain>
 <20101124023238.GA26540@tiny>
 <1290602771.2785.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290602771.2785.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Safford (safford@watson.ibm.com):
> On Tue, 2010-11-23 at 20:32 -0600, Serge Hallyn wrote:
> > Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > > Add internal kernel tpm_send() command used to seal/unseal keys.
> ... 
> > > +int tpm_send(u32 chip_num, void *cmd, size_t buflen)
> > 
> > Hate to nit-pick, but any particular reason you're not following the
> > rest of the file and using 'struct tpm_cmd_t *cmd' here?
> > 
> > Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> 
> We put some thought into this one. TPM command packets are
> binary blobs with lots of optional and variable length fields,
> and there are at least three common approaches to creating them:
> structures (as used in tpm.c), load/store (as used in trousers
> and trusted-keys), and an sprintf like format string (as used
> in the original libtpm.) Each has its advantages and disadvantages.
> Structures are nice for the simple TPM commands, but they become
> unwieldy for the complex commands like seal and unseal. Load/store
> is much more readable for the complex seal and unseal commands.
> Format strings are nice for creating the most complex commands
> in the fewest lines of code, but are way overkill for simple ones.
> 
> With the void *cmd, we are allowing the other modules to pick
> whichever method most suits their needs.

Jinkeys, that's complicated :)

But doesn't that mean that the transmit_cmd() parameters are lying?
Should the second argument for transmit_cmd() be a union?

(If only to help out the lamentable reader)

thanks,
-serge
