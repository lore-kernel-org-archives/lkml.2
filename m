Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2APUGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:06:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52137 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2APUGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:06:33 -0500
Date: Mon, 16 Jan 2012 20:06:18 +0000
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
Message-ID: <20120116200618.GN23916@ZenIV.linux.org.uk>
References: <cover.1326673414.git.luto@amacapital.net>
 <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 04:37:21PM -0800, Andy Lutomirski wrote:

> +	is_chrooted = (fs->root.mnt->mnt_mountpoint !=
> +		       fs->root.mnt->mnt_parent->mnt_root ||
> +		       fs->root.dentry != fs->root.mnt->mnt_root);

Folks, is it _that_ hard to at least try to compile your patches?  Hint:
this one will *not*.  That sad detail aside, this test would have been
a pile of garbage even on the kernels that used to have mnt_mountpoint
in struct vfsmount.  What *are* you trying to test here?  The last part
at least does make some sense - it's "process root happens to be the
root of some vfsmount".  The first part, though, makes no sense whatsoever;
it's "... and that vfsmount is mounted on top of root of some other
vfsmount".

Grr...  NAKed, with extreme prejudice.
