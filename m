Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2EYNyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:54:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2EYNyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:54:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1337951294.2351.34.camel@falcor>
References: <1337951294.2351.34.camel@falcor> <CALLzPKYVahsgcsyF0zMP+wLNAp5TeiGeofy5KJyMHkjsdyvo9Q@mail.gmail.com> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com> <8762blyedn.fsf@rustcorp.com.au> <6426.1337945879@redhat.com> 
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Fri, 25 May 2012 14:53:22 +0100
Message-ID: <3662.1337954002@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> The issue here is whether we want the integrity metadata for kernel
> modules to be stored differently than for all other files.

Surely it's handled differently.  The kernel is told by insmod what the
signature should be in your scheme rather than going looking for it itself.  In
such a case, why not include the signature in the module file?  It's more
efficient on the filesystem, doesn't require xattr support and is easier for
things like the initramfs composer to deal with.

Btw, am I right in thinking that with IMA, the kernel itself normally goes and
finds the signature (if there is one) for a file when it needs to open a file?
Do you only check the IMA when exec'ing a file or whenever you open it?

David
