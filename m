Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab0KPSy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:54:57 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39053 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147Ab0KPSyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:54:54 -0500
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
In-Reply-To: <26645.1289929851@redhat.com>
References: <1289918320.3188.16.camel@localhost.localdomain>
	 <1289849751.3027.17.camel@localhost.localdomain>
	 <1289694826.3257.82.camel@localhost.localdomain>
	 <1289595738.2731.80.camel@localhost.localdomain>
	 <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <26689.1289591135@redhat.com> <27900.1289597013@redhat.com>
	 <8268.1289837934@redhat.com> <23151.1289916524@redhat.com>
	 <26645.1289929851@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 13:54:50 -0500
Message-ID: <1289933690.2627.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 17:50 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > I actually like keyctl requiring 'trusted:' or 'user:'.  Forcing the
> > user to indicate which type of key they want, is actually good - no
> > misunderstandings.
> 
> You still need to prefix the description of a user-defined key so that you
> don't collide with other people who're also using user-defined keys for random things.

ok

> > Another benefit, would be allowing 'keyctl update' to update the key
> > description, not the key type.
> 
> You mean you want to change the description on a key?
> 
> David

No, this just updates the name of the key used to encrypt/decrypt the
encrypted key. For example, the encrypted key evm-key is initially
encrypted/decrypted using 'kmk-trusted'.  After the update, it is
encrypted/decrypted with 'kmk'.  Both now are trusted keys.

$ keyctl show
Session Keyring
       -3 --alswrv    500   500  keyring: _ses
117908125 --alswrv    500    -1   \_ keyring: _uid.500
501967942 --alswrv    500   500       \_ trusted: kmk-trusted
317523177 --alswrv    500   500       \_ encrypted: evm-key
666437381 --alswrv    500   500       \_ trusted: kmk
$ keyctl print 317523177
trusted:kmk-trusted 32 ca0ebb83594f14781460 ...

$ keyctl update 317523177 "update trusted:kmk"
$ keyctl print 317523177
trusted:kmk 32 ca0ebb83594f1478146 ....

Mimi

