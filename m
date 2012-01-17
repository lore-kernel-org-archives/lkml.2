Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab2AQKPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:15:40 -0500
Received: from mail2.shareable.org ([80.68.89.115]:37838 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2AQKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:15:37 -0500
Date: Tue, 17 Jan 2012 10:14:47 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Colin Walters <walters@verbum.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 4/4] Allow unprivileged chroot when safe
Message-ID: <20120117101447.GF7180@jl-vm1.vm.bytemark.co.uk>
References: <cover.1326673414.git.luto@amacapital.net>
 <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
 <1326741967.3467.8.camel@lenny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326741967.3467.8.camel@lenny>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Walters wrote:
> On Sun, 2012-01-15 at 16:37 -0800, Andy Lutomirski wrote:
> 
> > Because chroot is an easy way to break out of chroot jail, CAP_SYS_ADMIN
> > is still required if the caller is already chrooted.
> 
> This part is pretty gross.  It means it won't work for stuff like
> containers (systemd-nspawn etc.) and furthermore

> I have plans that involve running OS trees inside a chroot, and this
> would obviously not work for that.

Indeed, I do run many of my machines inside a chroot.
The real filesystem has:

    /distro/that
    /distro/newer
    /distro/this

instead of partitions.  I'm chroot'd and fully booted up in
/distro/this, although I can see files in the others and I might run a
few things from them as well.

This isn't "userland chroot", it's the top level of the process tree:
/distro/this/sbin/init.  It would be a shame if it behaved differently
just because "it's a chroot".

-- Jamie
