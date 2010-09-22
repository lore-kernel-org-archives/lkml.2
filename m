Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab0IVTJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:09:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345Ab0IVTJj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <20100922185328.GD19804@ZenIV.linux.org.uk>
References: <20100922.111019.200357319.davem@davemloft.net>
 <20100922183200.GC19804@ZenIV.linux.org.uk> <AANLkTi=DWk2_=wMqcM1jgJEuNRj_ni2OkM3osYCUg57Y@mail.gmail.com>
 <20100922185328.GD19804@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Sep 2010 12:08:53 -0700
Message-ID: <AANLkTi=pJUKRUQhpcVV8XAJF+BO1440v1Py5Opr34DR1@mail.gmail.com>
Subject: Re: [GIT] Sparc
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 11:53 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Um, no.  You've *already* called get_signal_to_deliver().  There had been
> no SIGSEGV in sight.  You happily went on to set a sigframe for e.g.
> SIGHUP, but ran out of stack.  At that point you get force_sigsegv()
> from handle_signal().  _NOW_ you have a pending SIGSEGV

Ahh. Ok. Different case from the one I thought you were worried about.
And yeah, I guess that one does require us to mess with the low-level
asm code (although I do wonder if we could not make the whole
do_notify_resume + reschedule code be generic C code - it's a lot of
duplicated subtle asm as it is).

                   Linus
