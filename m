Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2A3WKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:10:45 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58164 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2A3WKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:10:43 -0500
MIME-Version: 1.0
In-Reply-To: <1327960736.5355.5.camel@lenny>
References: <cover.1327858005.git.luto@amacapital.net> <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
 <1327960736.5355.5.camel@lenny>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jan 2012 14:10:22 -0800
Message-ID: <CALCETrWqOsWjnJOLD5TytOiSSiRE7wAwo6dRj5A7-jP-zEGa3A@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] Allow unprivileged chroot when safe
To: Colin Walters <walters@verbum.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
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

On Mon, Jan 30, 2012 at 1:58 PM, Colin Walters <walters@verbum.org> wrote:
> On Mon, 2012-01-30 at 08:17 -0800, Andy Lutomirski wrote:
>> Chroot can easily be used to subvert setuid programs.  If no_new_privs,
>> then setuid programs don't gain any privilege, so allow chroot.
>
> Is this needed/desired by anyone now, or are you just using it to "demo"
> NO_NEW_PRIVS?  I don't see it as very useful on its own, since in any
> "container"-type chroot you really want /proc and /dev, and your patch
> doesn't help with that.

It's a demo, but it could still be useful for container-ish things.
If something privileged sets up /proc, /sys, and /dev, then
unprivileged code can chroot into the container.  This would allow
much simpler implementations of tools like schroot.

>
> System daemons that do chroot for a modicum of security already start
> privileged, so this doesn't help them either.

With this change, they wouldn't need to start privileged.
(Admittedly, this isn't a great argument for this patch.)

It would be really nice to have unprivileged filesystem namespace
features, but that would be more complicated to do safely.

--Andy

>
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
Office: (310) 553-5322
Mobile: (650) 906-0647
