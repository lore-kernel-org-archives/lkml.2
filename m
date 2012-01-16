Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab2APUTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:19:00 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55402 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2APUS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:18:59 -0500
MIME-Version: 1.0
In-Reply-To: <1326741967.3467.8.camel@lenny>
References: <cover.1326673414.git.luto@amacapital.net> <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
 <1326741967.3467.8.camel@lenny>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jan 2012 12:18:37 -0800
Message-ID: <CALCETrVmn541_VGzRApb3n-yOWnBogeub0vhKWeVwsp3dNK-MQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] Allow unprivileged chroot when safe
To: Colin Walters <walters@verbum.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 11:26 AM, Colin Walters <walters@verbum.org> wrote:
> On Sun, 2012-01-15 at 16:37 -0800, Andy Lutomirski wrote:
>
>> Because chroot is an easy way to break out of chroot jail, CAP_SYS_ADMIN
>> is still required if the caller is already chrooted.
>
> This part is pretty gross.  It means it won't work for stuff like
> containers (systemd-nspawn etc.) and furthermore I have plans that
> involve running OS trees inside a chroot, and this would obviously not
> work for that.

Agreed.

Unprivileged bind mounts would be a much better approach, but that
would need some concept of an unprivileged user owning a namespace.
Maybe the namespace id work would make this work.

--Andy
