Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2ECF6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 01:58:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56088 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2ECF6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 01:58:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
References: <1335788867.29087.19.camel@localhost> <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
 <1335875321.26671.15.camel@localhost> <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 May 2012 22:57:58 -0700
X-Google-Sender-Auth: qBR0I8qag9wIW4kwns9evfMswpQ
Message-ID: <CA+55aFwvs8LHmThhMD14BJZ27JpQdD_xCytaDUeuCQJAy94LVQ@mail.gmail.com>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
To: Nick Piggin <npiggin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Jana Saout <jana@saout.de>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to actually add Peter and Ingo to the cc..

                    Linus

On Wed, May 2, 2012 at 10:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The word-at-a-time code assumes that no allocation will be the last
> page (whether kmalloc or normal page allocation), which was always
> somewhat optimistic but I thought it would be true on PC's.
>
> And that %rbp value does *not* look like end-of-memory, but maybe
> there is something else than just the CONFIG_DEBUG_PAGEALLOC that
> causes us to punch holes even in the kernel memory map.
>
> Peter, Ingo - do we unmap kernel pages for PAT etc attributes?
