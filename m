Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2APT0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:26:31 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36810 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760Ab2APT02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:26:28 -0500
X-Sasl-enc: d9gQ08wNbO1uzRe3ps10HeXqsh+CASjaFO7ulQgmZd1O 1326741987
Subject: Re: [PATCH 4/4] Allow unprivileged chroot when safe
From: Colin Walters <walters@verbum.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Date: Mon, 16 Jan 2012 14:26:05 -0500
In-Reply-To: <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
References: <cover.1326673414.git.luto@amacapital.net>
	 <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326741967.3467.8.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 16:37 -0800, Andy Lutomirski wrote:

> Because chroot is an easy way to break out of chroot jail, CAP_SYS_ADMIN
> is still required if the caller is already chrooted.

This part is pretty gross.  It means it won't work for stuff like
containers (systemd-nspawn etc.) and furthermore I have plans that
involve running OS trees inside a chroot, and this would obviously not
work for that.

Incidentally I ended up putting my setuid program here:
http://git.gnome.org/browse/linux-user-chroot/

Now unfortunately, even if we say that a new setuid program is the way
to gain these privileges, you still can't nest it, because all of these
things are predicated on disabling setuid programs.  But it would at
least not fail initially if your process was inside a chroot.






