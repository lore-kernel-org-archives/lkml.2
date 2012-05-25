Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2EYNJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:09:25 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59873 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab2EYNJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:09:19 -0400
Message-ID: <1337951294.2351.34.camel@falcor>
Subject: Re: [PATCH 00/23] Crypto keys and module signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Date: Fri, 25 May 2012 09:08:14 -0400
In-Reply-To: <6426.1337945879@redhat.com>
References: <CALLzPKYVahsgcsyF0zMP+wLNAp5TeiGeofy5KJyMHkjsdyvo9Q@mail.gmail.com>
	 <87obpfxdpr.fsf@rustcorp.com.au>
	 <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
	 <7474.1337782847@redhat.com> <8762blyedn.fsf@rustcorp.com.au>
	 <6426.1337945879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052513-4242-0000-0000-000001C6E83F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 12:37 +0100, David Howells wrote:
> Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
> 
> > > In some ways that is cleaner, but it's also nice to avoid adding another
> > > syscall.
> > 
> > There is no additional syscall.
> > signature is passed is 'ima=' parameter to init_module()
> > like
> 
> Exactly what I was thinking of, though I wouldn't call it "ima=" as that
> doesn't seem specific enough.

IMA-appraisal maintains the file integrity metadata.

> You could also append it to the binary image and have the kernel extract it
> from there as if the module file had had the signature attached during the
> build.
> 
> I don't particularly favour holding the signature in an xattr, though, as that
> assumes that underlying fs has the capability to hold it and means that the
> package installation mechanism must know how to fill in xattrs.

Labeling files for integrity is a general issue, not limited to kernel
modules/ELF files.  For this reason, we need a generic mechanism that
works for all files, not only those that are executables.  For local
files, such as configuration files, which are system specific, files are
labeled with hashes(IMA-appraisal) and HMAC(EVM).

Yes, the package update mechanisms will need to be modified to install
both the file data and the associated file metadata - hash, signature.
Tar supports xattrs.  The original CPIO format doesn't, but there are
extensions that do.

The issue here is whether we want the integrity metadata for kernel
modules to be stored differently than for all other files.

Mimi

