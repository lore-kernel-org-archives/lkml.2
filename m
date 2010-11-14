Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0KNAse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 19:48:34 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47683 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab0KNAsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 19:48:33 -0500
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <27900.1289597013@redhat.com>
References: <1289595738.2731.80.camel@localhost.localdomain>
	 <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <26689.1289591135@redhat.com>  <27900.1289597013@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 19:33:46 -0500
Message-ID: <1289694826.3257.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 21:23 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > > Why do you allow the master key to be supplied by a user-defined key rather
> > > than requiring a trusted-key unconditionally?
> > 
> > This is for systems without a TPM. The logic needs to exist, whether it
> > is here or in EVM.  By doing it here, a user could provide a passphrase
> > in the initramfs, which is used to decrypt the encrypted key.
> 
> I thought that might be the case.  In which case, it might be better to allow
> someone to add a trusted key, supplying both encrypted and unencrypted
> versions of the data so that the TPM need not be consulted.  You might want to
> mark such a key so that it can be seen when it is dumped.

At least to me, the name 'trusted' implies some form of HW. 

> But if you're going to use a user-defined key, you really need to prefix the
> description with something suitable.
> 
> David

Agreed. So instead of: 
	keyctl add encrypted name "new master-key-name keylen" ring

the description would be prefixed with the key type like:	
	keyctl add encrypted name "new trusted|user master-key-name keylen" ring

thanks,

Mimi

