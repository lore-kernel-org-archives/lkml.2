Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2APU0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:26:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44885 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2APU0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:26:12 -0500
Date: Mon, 16 Jan 2012 20:26:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 4/4] Allow unprivileged chroot when safe
Message-ID: <20120116202604.GO23916@ZenIV.linux.org.uk>
References: <cover.1326673414.git.luto@amacapital.net>
 <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
 <20120116200618.GN23916@ZenIV.linux.org.uk>
 <CALCETrU62cq43hd7Wray0eZQfbQ9+hkuuo9AzCFgrL_2h_v7qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU62cq43hd7Wray0eZQfbQ9+hkuuo9AzCFgrL_2h_v7qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:15:09PM -0800, Andy Lutomirski wrote:

> The first approach I tried was (from memory -- may not compile at all
> on any version) fs->root.mnt != fs->root.mnt->mnt_parent.  That didn't
> work.  The issue is that on dracut-based distros, AFAICT, the root (in
> the sense of the root of the tree of struct vfsmounts) is rootfs.  The
> apparent root (the filesystem containing /, /usr, etc) is mounted on
> top of (rootfs)/.  Dracut then does something with the effect of
> chroot("/").  So you end up with the vfsmount that contains "/" not
> being the actual root vfsmount.  But there's nothing hidden by the
> chroot -- even if fs->root.mnt pointed at rootfs, "/" would still
> follow the mountpoint into the actual filesystem.

That has nothing whatsoever to do with dracut.  _Everything_ ends up
that way; IOW, everything including init(8) runs chrooted into the
final userland root.  On any normal distro.  Your test is complete BS - e.g.
mount /dev/crap /mnt/blah
mount /dev/garbage /mnt/blah
chroot /mnt/blah
will *NOT* be chrooted per your definition.
