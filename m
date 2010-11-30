Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0K3PXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:23:18 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:45834 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab0K3PXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:23:16 -0500
Subject: Re: [PATCH v1.5 3/5] key: add tpm_send command
From: David Safford <safford@watson.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: kjhall@us.ibm.com, Serge Hallyn <serge.hallyn@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
In-Reply-To: <19268.1291127520@redhat.com>
References: <20101124023238.GA26540@tiny>
	 <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1290556456.2604.14.camel@localhost.localdomain>
	 <19268.1291127520@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Nov 2010 10:22:46 -0500
Message-ID: <1291130566.2737.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 14:32 +0000, David Howells wrote:
> Serge Hallyn <serge.hallyn@canonical.com> wrote:
> 
> > > +int tpm_send(u32 chip_num, void *cmd, size_t buflen)
> > 
> > Hate to nit-pick, but any particular reason you're not following the
> > rest of the file and using 'struct tpm_cmd_t *cmd' here?
> 
> Ummm...  Something else I've just noticed...
> 
> 	static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> 					       size_t bufsiz)
> 
> would suggest that buf is read-only, but tpm_transit() keeps casting it away,
> and especially, casts it away before passing it to chip->vendor.recv()...
> This would seem to indicate a logic error somewhere.
> 
> Certainly, tpm_atml_recv() modifies the buffer it is given to...

as does tpm_tis_recv(). By the TCG spec, the return data should go in the
same input buffer.

> I suspect the argument and reply buffer pointers should be passed separately.

It seems more like a spurious "const" in tpm_transmit(). This has been in the
code for a long time. Good catch. I'll draft a cleanup for these and some
other nits and send to Rajiv...

thanks!
dave

> David
> 

