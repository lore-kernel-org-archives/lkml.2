Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2AMA5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:57:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59238 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab2AMA5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:57:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
 <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com> <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jan 2012 16:57:20 -0800
X-Google-Sender-Auth: Dij0-dZKrh9fs2Sw1OFaeB8pASY
Message-ID: <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
To: Andrew Lutomirski <luto@mit.edu>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 4:42 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> That may prevent another use: set this new flag, chroot, drop
> privileges, accept network connections.  (The idea being that chroot
> might work unprivileged if this flag is set.)

Well, if you have privileges, then just do

   chroot();
   drop privileges

and if you depend on the new flag, then you do

   drop privileges
   set new flag
   chroot

and if you want to work either way then you just do

   error = chroot
   drop privileges
   set new flag
   if error
      chroot

which does the right thing regardless of whether you had privileges
and/or a new kernel or not.

In any of the three cases I don't see why you'd ever want to drop
privileges *after* setting the new flag.

                   Linus
