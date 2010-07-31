Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0GaTEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 15:04:25 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:51449 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab0GaTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 15:04:22 -0400
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Phil Pishioneri <pgp@psu.edu>, Volker.Lendecke@SerNet.DE,
        Jeremy Allison <jra@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jan Engelhardt <jengelh@medozas.de>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
In-Reply-To: <09B770A6-48DB-4296-B6C2-BF46D4DC7E57@dilger.ca>
References: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	 <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	 <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
	 <E1Obxpd-00CRIo-SF@intern.SerNet.DE>
	 <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>
	 <20100722162712.GB10352@jeremy-laptop>
	 <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
	 <1279817930.3621.14.camel@heimdal.trondhjem.org>
	 <20100722180204.GA32008@samba1> <E1Oc08W-00CZuz-Ns@intern.SerNet.DE>
	 <1279825160.3621.71.camel@heimdal.trondhjem.org> <4C5311F4.2050100@psu.edu>
	 <1280513506.12852.22.camel@heimdal.trondhjem.org>
	 <09B770A6-48DB-4296-B6C2-BF46D4DC7E57@dilger.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 15:03:52 -0400
Message-ID: <1280603032.3125.24.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 14 msgs/h 1 sum rcpts/h 21 sum msgs/h 3 total rcpts 742 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: F72EEAC03FBC93B3AF6CDF4F1B7D913D98A6898D
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 297 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-31 at 12:41 -0600, Andreas Dilger wrote:
> On 2010-07-30, at 12:11, Trond Myklebust wrote:
> > Your Mac has a perfectly functional CIFS client, as do your Linux boxes.
> > They both interoperate just fine with Samba, and would presumably
> > continue to do so if someone were to decide to reuse the ctime field on
> > your Samba box as storage for a create time.
> 
> CIFS doesn't support symlinks (they just appear as the referenced file), so I've had applications that scan the filesystem recurse indefinitely due to symlinked directories on a CIFS share appearing as hard-linked directories on the client.  This doesn't happen when the filesystem is accessed via NFS.

Sigh... So please explain how it would be useful to export that
particular filesystem through _both_ CIFS and NFS?

My point was that in most circumstances you want to export either
through CIFS or through NFS, but very rarely both.

I also made the point that converting ctime into a creation time would
break NFS, but it would be a limited breakage, mainly affecting the
client's ability to detect ACL changes, and possibly causing the inode
to get temporarily updated with stale attribute information on occasion
due to out-of-order RPC replies.

  Trond

