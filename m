Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0GaSsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 14:48:43 -0400
Received: from borg.medozas.de ([188.40.89.202]:55226 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab0GaSsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 14:48:41 -0400
Date: Sat, 31 Jul 2010 20:48:39 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andreas Dilger <adilger@dilger.ca>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
        Phil Pishioneri <pgp@psu.edu>, Volker.Lendecke@SerNet.DE,
        Jeremy Allison <jra@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
 file stats available [ver #6]
In-Reply-To: <09B770A6-48DB-4296-B6C2-BF46D4DC7E57@dilger.ca>
Message-ID: <alpine.LSU.2.01.1007312048200.15118@obet.zrqbmnf.qr>
References: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE> <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com> <E1Obxpd-00CRIo-SF@intern.SerNet.DE>
 <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com> <20100722162712.GB10352@jeremy-laptop> <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com> <1279817930.3621.14.camel@heimdal.trondhjem.org> <20100722180204.GA32008@samba1>
 <E1Oc08W-00CZuz-Ns@intern.SerNet.DE> <1279825160.3621.71.camel@heimdal.trondhjem.org> <4C5311F4.2050100@psu.edu> <1280513506.12852.22.camel@heimdal.trondhjem.org> <09B770A6-48DB-4296-B6C2-BF46D4DC7E57@dilger.ca>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2010-07-31 20:41, Andreas Dilger wrote:
>On 2010-07-30, at 12:11, Trond Myklebust wrote:
>> Your Mac has a perfectly functional CIFS client, as do your Linux boxes.
>> They both interoperate just fine with Samba, and would presumably
>> continue to do so if someone were to decide to reuse the ctime field on
>> your Samba box as storage for a create time.
>
>CIFS doesn't support symlinks (they just appear as the referenced
>file), so I've had applications that scan the filesystem recurse
>indefinitely due to symlinked directories on a CIFS share appearing
>as hard-linked directories on the client. This doesn't happen when
>the filesystem is accessed via NFS.

This shouldn't go on indefinitely - PATH_MAX is reached at some point.
