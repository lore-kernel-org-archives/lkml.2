Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab2DKSEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:04:37 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61997 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab2DKSEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:04:33 -0400
MIME-Version: 1.0
In-Reply-To: <4F85C640.3060608@zytor.com>
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com>
 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
 <4F7F1864.8090606@zytor.com> <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com>
 <4F85C640.3060608@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Apr 2012 11:04:10 -0700
X-Google-Sender-Auth: ODhzSvPPagqMH-alz-1eBaVvzxc
Message-ID: <CA+55aFzT1OomhJkDx+crnqRmH-kowAM4w8SRqsmPVMyh8gEwZQ@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 10:58 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> But it still has the same braindamage: one system call per loop
> invocation, and we can do better.  I would much rather see fdwalk() in SUS.

Why would we bother to do better?

System calls are cheap, and usually you actually do want to do
something about the fd, so you actually want to iterate over them.

I'd much rather have simple cheap interfaces than anything else. If
SuS has a F_NEXT fcntl, let's just do that thing. Much simpler than
doing something more complex and then just having to emulate the
simple thing in user space anyway.

If a standard interface exists, we should just use it.

                  Linus
