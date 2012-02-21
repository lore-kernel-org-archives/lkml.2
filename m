Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2BUXUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:20:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38594 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2BUXUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:20:04 -0500
MIME-Version: 1.0
In-Reply-To: <1329865848.18384.64.camel@edumazet-laptop>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFxkbsZN3yG6d9DPGiXmiuX-wOURJcC0hAUN3Qbykv1UhQ@mail.gmail.com>
 <1329865848.18384.64.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 15:19:43 -0800
X-Google-Sender-Auth: zUsaAudfHrTL6QeA0XbZkwRmBsI
Message-ID: <CA+55aFz3e8OMRiprJmhZ_Y6SMmDCrmW18et51s24_nnn2WoT-A@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 3:10 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Yep, this is what I thought, but when this was raised last september,
> both Andrew and Andi disagreed.
>
> https://lkml.org/lkml/2011/10/6/389

Well, I agree that it *could* break things, but considering that at
least glibc does the sign-exitension, any code that puts a large
number in the 'timeout' field would *already* have broken.

Which is why I think we should first try to fix the system call
interface - because it's the simpler patch, and it's the
RightThing(tm) to do from a standards standpoint. It's also almost
guaranteed to work, exactly because of how glibc already does that
conversion.

But if something does break - however unlikely and perverse the code
has to be to be able to do that - we'd clearly have to undo that "just
fix sys_poll()" and use Thomas' patch to have a compat_sys_poll()
instead.

I just don't like the notion of doing that silly compat thing when it
really shouldn't be needed to begin with.

                   Linus
