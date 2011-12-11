Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab1LKFLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 00:11:52 -0500
Received: from ozlabs.org ([203.10.76.45]:43180 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab1LKFLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 00:11:49 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan@linux.intel.com, alan.cox@intel.com,
        Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
In-Reply-To: <20111210103723.6c89405f@infradead.org>
References: <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk> <2657.1323456206@redhat.com> <8739csq5ac.fsf@rustcorp.com.au> <20111210103723.6c89405f@infradead.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 11 Dec 2011 15:29:10 +1030
Message-ID: <87mxazog9t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Dec 2011 10:37:23 -0800, Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > Yes, there may be more than stripped and unstripped.  You may need to
> > do fancy things.  But now, adding a signature is so easy that it's
> > not a real problem.  And we can always have a hook, like:
> > 
> >         if VARIANTS=`make-module-variants $MOD`; then
> >                 for m in $VARIANTS; do sign $m >> $MOD; rm $m; done
> >         fi
> 
> but that requires you to keep the key around.

No, that's the point.  This was proposed as part of the kernel build.

make-module-variants does one or more transforms on the module
(eg. strip) and outputs the names of the results.  If they're not
reproducable, you have to keep them somewhere, yes, rather than remove
them as here.

> the most simple and common deployment of this is to generate a key,
> build the public key into the kernel, sign the modules as you build the
> kernel, and then destroy the key.
> And THEN it gets deployed.

Indeed.

You have to demonstrate why the simplest way won't work, before putting
450 lines of extra checking into the kernel.  Particularly since it's
supposed to protect against malicious modules, so I need to *really*
carefully review it.

Thanks,
Rusty.
