Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2EYOlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:41:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41946 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2EYOlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:41:00 -0400
Message-ID: <1337956828.2351.68.camel@falcor>
Subject: Re: [PATCH 00/23] Crypto keys and module signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Date: Fri, 25 May 2012 10:40:28 -0400
In-Reply-To: <3662.1337954002@redhat.com>
References: <1337951294.2351.34.camel@falcor>
	 <CALLzPKYVahsgcsyF0zMP+wLNAp5TeiGeofy5KJyMHkjsdyvo9Q@mail.gmail.com>
	 <87obpfxdpr.fsf@rustcorp.com.au>
	 <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
	 <7474.1337782847@redhat.com> <8762blyedn.fsf@rustcorp.com.au>
	 <6426.1337945879@redhat.com>  <3662.1337954002@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052514-4242-0000-0000-000001C71FF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 14:53 +0100, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > The issue here is whether we want the integrity metadata for kernel
> > modules to be stored differently than for all other files.
> 
> Surely it's handled differently.  The kernel is told by insmod what the
> signature should be in your scheme rather than going looking for it itself.  In
> such a case, why not include the signature in the module file?  It's more
> efficient on the filesystem, doesn't require xattr support and is easier for
> things like the initramfs composer to deal with.

Yes, unfortunately, it is handled differently.  Instead of passing a
file descriptor, a buffer containing the file data is passed.  Without
the file descriptor, you also need to pass the file metadata, in this
case, the signature as well.  Whether the signature is passed as a
separate parameter or appended to the file, it still is being passed to
the kernel.

> Btw, am I right in thinking that with IMA, the kernel itself normally goes and
> finds the signature (if there is one) for a file when it needs to open a file?
> Do you only check the IMA when exec'ing a file or whenever you open it?
> 
> David

IMA measures a file and appraises file data integrity based on the IMA
measurement/appraisal policy.  There are currently 3 hooks: open -
ima_file_check(), exec - ima_bprm_check() and mmap - ima_file_mapp().

I don't know the reasons or history for passing the file data content,
instead of a file descriptor, but if a file descriptor were passed, then
module integrity appraisal could simply be another integrity hook.

Mimi

