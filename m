Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1HQJW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:22:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1HQJW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:22:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [RFC,PATCH] arch/arm: compute and export NR_syscalls
Date: Wed, 17 Aug 2011 11:22:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Frysinger <vapier@gentoo.org>,
        linux-arm-kernel@lists.infradead.org
References: <1313529267-4428-1-git-send-email-wad@chromium.org> <CABqD9hYavCxA38GbBhbCmBT+PEQQsvhbF4U7xY8P8ygbFy+=Ag@mail.gmail.com> <20043.28045.613130.691498@pilspetsen.it.uu.se>
In-Reply-To: <20043.28045.613130.691498@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108171122.49009.arnd@arndb.de>
X-Provags-ID: V02:K0:fY6zZqcZTW80XcjxxOgTm8wp7+wj31VAtZTaCNCbEju
 5FRGo2qBSHAtxA+HJmd1o+yo16nW9pLQfXTwjeZ2h9P9BpzHlv
 pKvy9yDQxmXA4cwbySrU+FKL9WmT8EuT/CNUC7CfdTWCAePH+Y
 P31BIiRqBdsGvZcazkrSSah1ycp1oskbOFh83GOQ4JlUiOg4hl
 VGQQppJdYHNUN42Aa0EKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011, Mikael Pettersson wrote:
>  > I proposed this approach based solely on prior threads I've seen. E.g.,
>  > - https://lkml.org/lkml/2007/6/1/427
>  >   (don't just #define)
>  > - https://lkml.org/lkml/2009/8/27/280
>  >   (todo: x86-32 to move to x86-64)
>  > 
>  > If a single line #define is good enough, then it certainly works for me.
> 
> Yes, the one-line #define NR_syscalls in unistd.h is a perfectly adequate,
> if not entirely elegant, solution.  Adding asm-export.c just for this is
> waaay overkill.

Right. While the main problem with having the constant in asm/unistd.h
(needs to be kept in sync when adding new syscalls) is an annoyance,
the suggested approach is adding more complexity than necessary.

If you want to have the value automatically computed, I'd suggest
moving the format of unistd.h over to a method like the one used
by x86-64 and asm-generic, which is to combine the syscall number
definitions with the list of syscall pointers that currently reside
in arch/arm/kernel/calls.S, for the added benefit that it's easier to
keep the two in sync as well.

The main question is what Russell's preference is on the alternatives.

	Arnd
