Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab2LCEJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 23:09:38 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52864 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab2LCEJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 23:09:35 -0500
Message-ID: <1354507769.2737.59.camel@falcor.watson.ibm.com>
Subject: Re: [RFC][PATCH 2/2] modsig: differentiate between ephemeral and
 persistent key names
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, David Howells <dhowells@redhat.com>
Date: Sun, 02 Dec 2012 23:09:29 -0500
In-Reply-To: <874nk4j580.fsf@rustcorp.com.au>
References: <1353939786-4829-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1353939786-4829-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <874nk4j580.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120304-5806-0000-0000-00001C77D66E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-03 at 11:56 +1030, Rusty Russell wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> > Using the same name for ephemeral and "persistent" keys results
> > in deleting the "persistent" key.  This patch renames the normal
> > kbuild asymmetric key pair name to "default_signing_key" and the
> > ephemeral key pair name to "ephemeral_signing_key".
> 
> I like the idea: I was always uncomfortable with the mixing of
> persistent and temporary keys.  But it's a bit misguided, because surely
> persistent keys don't belong in the build tree at all.

The original intent of the patch was to differentiate between a key
generated as part of the kbuild process, that exists for an indefinite
period of time, versus an ephemeral key, which is created and
immediately thrown away, after signing the kernel modules.

> 
> How about we do something like:
> 
> # Default to temporary keys
> MODKEYPREFIX = ./temp_signing_key
> 
> MODSECKEY = $(MODKEYPREFIX).priv
> MODPUBKEY = $(MODKEYPREFIX).x509
> 
> Then encourage people to do:
> 
>         make MODKEYPREFIX=...

Although your suggestion addresses a different use case scenario, I like
it a lot.  Fortunately, it also works for the above ephemeral use case.
The default temporary key would be persistent across builds, while an
ephemeral key could be defined as "MODKEYPREFIX
= ./ephemeral_signing_key".

My main concern is having to force modsign_pubkey to be rebuilt each and
every time, since there is no way of knowing which key was previously
included.

> We could also use a config option to set the path, but that's probably
> less convenient.

Definitely less convenient.  I assume the normal use case for developers
would be multiple builds, followed by an install.  Each build shouldn't
require regenerating a new keypair, nor at the point that we're ready to
sign and install the kernel modules and image, do we want to change
the .config, which would result in additional, as you put it, root owned
turds.

thanks,

Mimi

