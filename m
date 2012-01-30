Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2A3W22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:28:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51042 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2A3W20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:28:26 -0500
MIME-Version: 1.0
In-Reply-To: <1327961884.5882.11.camel@gandalf.stny.rr.com>
References: <cover.1327858005.git.luto@amacapital.net> <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
 <1327960736.5355.5.camel@lenny> <1327961884.5882.11.camel@gandalf.stny.rr.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jan 2012 14:28:05 -0800
Message-ID: <CALCETrWX6OsuOcD+ctyNAx7xyU_DL1_Mqb9+MYs5J9xubX1vmA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] Allow unprivileged chroot when safe
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Colin Walters <walters@verbum.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, jmorris@namei.org,
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

On Mon, Jan 30, 2012 at 2:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-01-30 at 16:58 -0500, Colin Walters wrote:
>> On Mon, 2012-01-30 at 08:17 -0800, Andy Lutomirski wrote:
>> > Chroot can easily be used to subvert setuid programs.  If no_new_privs,
>> > then setuid programs don't gain any privilege, so allow chroot.
>>
>> Is this needed/desired by anyone now, or are you just using it to "demo"
>> NO_NEW_PRIVS?  I don't see it as very useful on its own, since in any
>> "container"-type chroot you really want /proc and /dev, and your patch
>> doesn't help with that.
>>
>> System daemons that do chroot for a modicum of security already start
>> privileged, so this doesn't help them either.
>
> I thought this was all for sandboxing? If a browers (or user) wants to
> run some untrusted code, perhaps a chroot is the best way to do so. It
> just will break if it needs to access /proc or /dev. And perhaps we
> don't want untrusted code accessing /proc and /dev.

True.  A BPF seccomp filter that disables open, bind, connect, rename,
unlink, etc may be better, though.

(I like this patch, although I don't think it's at all essential.  It
could certainly be made more flexible and more useful, but it would
get considerably more complicated in the process.)

--Andy
