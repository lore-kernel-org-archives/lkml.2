Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2I0CFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:05:43 -0400
Received: from ozlabs.org ([203.10.76.45]:41776 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab2I0CFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:05:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
In-Reply-To: <8168.1348650575@warthog.procyon.org.uk>
References: <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 27 Sep 2012 09:42:59 +0930
Message-ID: <87bogs492s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> We do a very simple search for a particular string appended to the module
>> (which is cache-hot and about to be SHA'd anyway).  There's both a config
>> option and a boot parameter which control whether we accept (and taint) or
>> fail with unsigned modules.
>
> I've adjusted your patch description to this:
>
>     We do a very simple search for a particular string appended to the module
>     (which is cache-hot and about to be SHA'd anyway).  There's both a config
>     option and a boot parameter which control whether we accept or fail with
>     unsigned modules and modules that are signed with an unknown key.
>
>     If module signing is enabled, the kernel will be tainted if a module is
>     accepted that is unsigned or has a signature for which we don't have the
>     key.
>
> I think it's worth mentioning the policy for unknown keys and worth making
> clear under what circumstances we mean the kernel to be tainted.

Great!  I checked your Kconfig help, too, which is states it clearly:

config MODULE_SIG_FORCE
	bool "Require modules to be validly signed"
	depends on MODULE_SIG
	help
	  Reject unsigned modules or signed modules for which we don't have a
	  key.  Without this, such modules will simply taint the kernel.


Which is really nice, since the kernel Kconfig help messages tend to
suck.

Thanks,
Rusty.
