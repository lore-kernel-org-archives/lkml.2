Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2AMAm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:42:26 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56495 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756301Ab2AMAmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:42:24 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
References: <1326411506-16894-1-git-send-email-wad@chromium.org> <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 Jan 2012 16:42:02 -0800
X-Google-Sender-Auth: Nna98zmokcKkQcTrSn-9aVASfSU
Message-ID: <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 3:47 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 12, 2012 at 3:38 PM, Will Drewry <wad@chromium.org> wrote:
>> This patch is a placeholder until Andy's (luto@mit.edu) patch arrives
>> implementing Linus's proposal for applying a "this is a process that has
>> *no* extra privileges at all, and can never get them".
>
> I think we can simplify and improve the naming/logic by just saying
> "can't change privileges".
>
> I'd argue that that even includes "can't drop them", just to make it
> really clear what the rules are.

That may prevent another use: set this new flag, chroot, drop
privileges, accept network connections.  (The idea being that chroot
might work unprivileged if this flag is set.)

--Andy
