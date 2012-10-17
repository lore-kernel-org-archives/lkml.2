Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab2JQCDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:03:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38454 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab2JQCDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:03:36 -0400
MIME-Version: 1.0
In-Reply-To: <20121015161401.17133.8590.stgit@warthog.procyon.org.uk>
References: <20121015161401.17133.8590.stgit@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Oct 2012 19:03:15 -0700
X-Google-Sender-Auth: SQl-WyZY6nVKH1itjdaTHGujVb0
Message-ID: <CA+55aFy1c1Pn_czRoyybCGCsT89Rc7-kHfNCnH9xvc=p=1jrkQ@mail.gmail.com>
Subject: Re: [PATCH] Make uapi/linux/irqnr.h non-empty
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Alessandro Suardi <alessandro.suardi@gmail.com>,
        Viresh Kumar <viresh.kumar@st.com>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 9:14 AM, David Howells <dhowells@redhat.com> wrote:
> uapi/linux/irqnr.h was emitted by the UAPI disintegration script as an empty
> file because the parent linux/irqnr.h had no UAPI stuff in it, despite being
> marked with "header-y".
>
> Unfortunately, it patch deletes the empty file when applying a kernel patch.

Sadly, this is by far not the only empty file we now have, so applying
this patch seems pointless..

Doing a "git clean -dqfx" followed by "find . -size 0" shows quite a
few empty files, most of them being Kbuild files, and most of them
having come in through the UAPI patches. Maybe some of those *should*
be removed?

Some of the empty files seem pointless. The

  arch/arm/mach-spear13xx/include/mach/spear1310_misc_regs.h

file, for example, has always been empty, and does not seem to be actually used.

Hmm? I added a few more people to the cc list.

                 Linus
