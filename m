Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1AZM5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:57:20 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53613 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1AZM5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:57:17 -0500
Subject: Re: [RFC][PATCH v3 5/6] encrypted-keys: add ecryptfs format support
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
In-Reply-To: <6520.1296040725@redhat.com>
References: <1295887497-20198-6-git-send-email-roberto.sassu@polito.it>
	 <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
	 <6520.1296040725@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 07:57:11 -0500
Message-ID: <1296046631.10455.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 11:18 +0000, David Howells wrote:
> Roberto Sassu <roberto.sassu@polito.it> wrote:
> 
> >  security/keys/keys_ecryptfs.c            |   81 ++++++++++++++++++++++++++++++
> >  security/keys/keys_ecryptfs.h            |   30 +++++++++++
> 
> Can you rename these files please?  The 'keys' prefix is redundant.  They're
> obviously about keys, or they shouldn't be in this directory.  I'd suggest
> something like 'ecryptfs_format.[ch]'.
> 
> You might want to make a subdir here specifically for the trusted and
> encrypted keys and all their formats and move those files into it if you're
> going to have lots of formats.

We think most other encrypted key usages will be unformatted. Perhaps,
for the time being, we should wait and see before making an 'encrypted'
subdirectory. 

Mimi

> >  /*
> > + * valid_ecryptfs_desc - verify the description of a new/loaded encrypted key
> > + *
> > + * The description of a encrypted key with format 'ecryptfs' must contain
> > + * exactly 16 hexadecimal characters.
> > + *
> > + */
> > +static int valid_ecryptfs_desc(const char *ecryptfs_desc)
> > +{
> 
> I think we need an additional key type operation - one that allows you to pass
> judgement on the description to be given for a key in key_alloc().  On the
> other hand, this doesn't help here as you can't do a full check on the key
> description without the payload.
> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


