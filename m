Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab1F3QHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:07:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999Ab1F3QHw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:07:52 -0400
MIME-Version: 1.0
In-Reply-To: <4E0C7C95.4070803@akkadia.org>
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
 <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com> <4E0ADF27.5070805@akkadia.org>
 <BANLkTi=dQRi82gkDwtR3Kh2R7f0uGu7HpQ@mail.gmail.com> <BANLkTi=pUZnhBa9W0eobQ_RWQGtMZ3u6Eg@mail.gmail.com>
 <4E0BE6A9.3040708@akkadia.org> <4E0C7C95.4070803@akkadia.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Jun 2011 09:07:10 -0700
Message-ID: <BANLkTim=whb61nbCTH-jH6cYdLrja8VCSQ@mail.gmail.com>
Subject: Re: [PATCH] Add cloexec information to fdinfo
To: Ulrich Drepper <drepper@akkadia.org>
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        viro@zeniv.linux.org.uk, wilsons@start.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 6:39 AM, Ulrich Drepper <drepper@akkadia.org> wrote:
>
> One more reason to at least not use the patch as you have it right now.
>  If a file descriptor was opened with O_CLOEXEC but subsequently the bit
> has been reset using fcntl() the f_flags value would still have the
> O_CLOEXEC bit set.

Umm. Look at my patch again. It masks the O_CLOEXEC bit *exactly*
because the bit is useless as it is now.

Which is why your previous objection was so silly too and I didn't
even bother replying to the blather. O_CLOEXEC at open time has no
special magical meaning. The only meaningful value for that bit is the
current one.

Which is exactly what my patch did.

> If you don't like the separate cloexec line, at least reset the
> O_CLOEXEC bit in the f_flags output if the FD_ISSET() test returns zero.

How about you just read the patch again?

This issue is closed as far as I am concerned. I repeat from my previous email:

  "I'm not going to commit it, but if others think this is a reasonable
   thing to do and remind me during the next merge window, we can
   do it then."

Gaah.

                      Linus
