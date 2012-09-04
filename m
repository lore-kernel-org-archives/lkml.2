Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2IDNnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:43:15 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46694 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab2IDNnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:43:12 -0400
Message-ID: <1346766048.2384.37.camel@falcor>
Subject: Re: [RFC] module: signature infrastructure
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Howells <dhowells@redhat.com>,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2012 09:40:48 -0400
In-Reply-To: <CALLzPKYO7KyiZpC4uUy+4VueLiVM0YqphtAVBhRd1VW_AryyQw@mail.gmail.com>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
	 <87627ufi2h.fsf@rustcorp.com.au>
	 <CALLzPKaA3MYncJD1X6B8f3p-R6FVA5-WDF-h6GGwdtinNpjqmw@mail.gmail.com>
	 <CALLzPKYO7KyiZpC4uUy+4VueLiVM0YqphtAVBhRd1VW_AryyQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090413-5518-0000-0000-000007587040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 15:21 +0300, Kasatkin, Dmitry wrote:
> On Tue, Sep 4, 2012 at 3:07 PM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
> > Hi,
> >
> > Please read bellow...
> >
> > On Tue, Sep 4, 2012 at 8:55 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> OK, I took a look at the module.c parts of David and Dmitry's patchsets,
> >> and didn't really like either, but I stole parts of David's to make
> >> this.
> >>
> >> So, here's the module.c part of module signing.  I hope you two got time
> >> to discuss the signature format details?  

The integrity subsystem currently defines 3 extended attribute formats
in security/integrity.h.

enum evm_ima_xattr_type {
        IMA_XATTR_DIGEST = 0x01,
        EVM_XATTR_HMAC,
        EVM_IMA_XATTR_DIGSIG,
};

integrity_digsig_verify() is called to appraise EVM signatures stored as
EVM_IMA_XATTR_DIGSIG.  In Dmitry's patches, this same call is used to
appraise modules.  If you decide to define a new format, it should be
included here as well.

> Mimi suggested a scheme where
> >> the private key would never be saved on disk (even temporarily), but I
> >> didn't see patches.  Frankly it's something we can do later; let's aim
> >> at getting the format right for the next merge window.

Right, the key is a build issue, which doesn't affect the format.

> > In our patches key is stored on the disc in encrypted format...

An updated version of Dmitry's patches are in the 'modsig' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/kasatkin/linux-digsig. For
now, although commit 59f1d53 "modsig: build rules and scripts to
generate keys and sign modules" writes the ephemeral key to disk, it is
encrypted.

thanks,

Mimi

