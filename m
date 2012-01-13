Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab2AMBl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:41:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44077 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2AMBlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:41:55 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hZCpFM4fN9p3vmnGeLVbvoDtTgbiovz=RsSkjH6sv=xBQ@mail.gmail.com>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
 <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
 <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
 <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
 <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com> <CABqD9hZCpFM4fN9p3vmnGeLVbvoDtTgbiovz=RsSkjH6sv=xBQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 Jan 2012 17:41:33 -0800
X-Google-Sender-Auth: -jINoJ7CMaozEmc6KPVJ1eADej4
Message-ID: <CAObL_7Fr-yV33jobSa3g_WqVJar-5x5oQM0t8GJxcLFsuBhLtg@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
To: Will Drewry <wad@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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

On Thu, Jan 12, 2012 at 5:37 PM, Will Drewry <wad@chromium.org> wrote:
> On Thu, Jan 12, 2012 at 7:11 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> (Also, preventing dropping of privileges will probably make a patch
>> more complicted -- I'll have to find and update all the places that
>> allow dropping privileges.)
>
> An alternative approach might be that the restricted bit drops all
> privileges that allows privilege changes in either direction.  E.g.,
> - set restricted bit
> -- adds a check anywhere MNT_NOSUID is
> -- sets securebit to SECURE_NOROOT|..LOCKED
> -- drops CAP_SETUID, CAP_DAC_OVERRIDE, ...
> -- set the caps bounding set to the minimum the restricted bit allows
>
> That may deviate from the intent (by re-using caps), but it could keep some
> of the privilege transition checking code the same.

I'm not sure it'll be much of a simplification.  The entire patch is
45 lines right now :)  I'll test it and send it out.

FWIW, though, it breaks apparmor (intentionally).  Can any of you
either explain what *should* happen or (better) volunteer to fix it?
It should be about three lines of code for someone who understands
what's going on.  I don't have an apparmor system, so I can't really
test it.

--Andy

>
> Just a thought,
> will
