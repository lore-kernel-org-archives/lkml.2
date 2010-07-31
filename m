Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0GaT1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 15:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab0GaT1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 15:27:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1280599521.2720.5.camel@segv.aura.of.mankind>
References: <1280599521.2720.5.camel@segv.aura.of.mankind> <1280524978.2452.9.camel@segv.aura.of.mankind> <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr> <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE> <AANLkTikBCXK6uEw <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com> <3533.1280595212@redhat.com> 
To: utz lehmann <lkml123@s2y4n2c.de>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Jeremy Allison <jra@samba.org>, Volker.Lendecke@sernet.de,
        Jan Engelhardt <jengelh@medozas.de>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsde@jasper.es
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Sat, 31 Jul 2010 20:26:49 +0100
Message-ID: <5618.1280604409@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

utz lehmann <lkml123@s2y4n2c.de> wrote:

> How does this works right with noatime or relatime (which is default)?

Don't do that then.

> We had used FS-Cache with a few 10000s files cached. Doesn't it mean
> that the cleanup has to stat them all?

Yes.

> Why didn't cachefilesd managed the cache index in a separate database
> like other caches?

Because using atime is much simpler since the filesystem updates it
automatically.  If you have a separate database then you have redundant
information and you need to maintain metadata integrity which has a cost, both
in terms of disk usage and performance.  I'm working on it, but you don't get
it for free.

David
