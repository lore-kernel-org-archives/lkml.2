Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1LELoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:44:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab1LELoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:44:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4EDCABBD.9020401@intel.com>
References: <4EDCABBD.9020401@intel.com> <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Subject: Re: [RFC][PATCH 00/16] Crypto keys and module signing [ver #2]
Date: Mon, 05 Dec 2011 11:43:39 +0000
Message-ID: <776.1323085419@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <h.peter.anvin@intel.com> wrote:

> Do we really need the complexity of a full OpenPGP parser?  Parsers are
> notorious security problems.

Actually, I don't have a full PGP parser.  I only handle the minimum I need.
It can parse the packet stream, public key packets and signature packets.
That's it.  I cannot guarantee that GPG is always going to put packets in the
stream in the same order, and dealing with the possible variation should be
simple enough.

Note that it might be possible to share the parser with other things like
eCryptFS.

> Furthermore, using DSA in anything but a hard legacy application is not
> something you want to encourage, so why support DSA?

Because DSA is what Red Hat currently uses in its module signing.  So the first
thing to do was to get that working again and then work on getting RSA working.
If I just jumped straight into the RSA parser, I would have a lot more stuff
that might be wrong; doing DSA first at least validated the common stuff.

However, we don't have to include the DSA stuff in the kernel; I can always
discard that patch from the upstream-aimed patchset.

David
