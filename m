Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1LIMG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 07:06:26 -0500
Received: from ozlabs.org ([203.10.76.45]:57155 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab1LIMGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:06:24 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
In-Reply-To: <20111202184651.21874.57769.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 09 Dec 2011 21:48:45 +1030
Message-ID: <87boriouwa.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Dec 2011 18:46:51 +0000, David Howells <dhowells@redhat.com> wrote:
> Signed modules may be safely stripped as the signature only covers those parts
> of the module the kernel actually uses and any ELF metadata required to deal
> with them.  Any necessary ELF metadata that is affected by stripping is
> canonicalised by the sig generator and the sig checker to hide strip effects.
> 
> This permits the debuginfo to be detached from the module and placed
> in another spot so that gdb can find it when referring to that module
> without the need for multiple signed versions of the module.  Such is
> done by rpmbuild when producing RPMs.
> 
> It also permits the module to be stripped as far as possible for when modules
> are being reduced prior to being included in an initial ramdisk composition.

And adds a great deal of code in a supposedly security-sensitive path to
achieve it.

How about simply append a signature to the module?  That'd be about 20
lines of code to carefully check the bounds of the module to figure out
where the signature is.  You could even allow multiple signatures, then
have one for stripped, and one for non-stripped versions.

Sure, you now need to re-append that after stripping, but that's not the
kernel's problem.

Cheers,
Rusty.
PS.  Yay for finding out about module patches via LWN!  How would you
     get this in without my ack, FFS?
  
  
