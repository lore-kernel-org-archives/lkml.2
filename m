Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2EYLiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab2EYLiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:38:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALLzPKYVahsgcsyF0zMP+wLNAp5TeiGeofy5KJyMHkjsdyvo9Q@mail.gmail.com>
References: <CALLzPKYVahsgcsyF0zMP+wLNAp5TeiGeofy5KJyMHkjsdyvo9Q@mail.gmail.com> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com> <8762blyedn.fsf@rustcorp.com.au>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Fri, 25 May 2012 12:37:59 +0100
Message-ID: <6426.1337945879@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:

> > In some ways that is cleaner, but it's also nice to avoid adding another
> > syscall.
> 
> There is no additional syscall.
> signature is passed is 'ima=' parameter to init_module()
> like

Exactly what I was thinking of, though I wouldn't call it "ima=" as that
doesn't seem specific enough.

You could also append it to the binary image and have the kernel extract it
from there as if the module file had had the signature attached during the
build.

I don't particularly favour holding the signature in an xattr, though, as that
assumes that underlying fs has the capability to hold it and means that the
package installation mechanism must know how to fill in xattrs.

David
