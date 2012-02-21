Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2BUXKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:10:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51380 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab2BUXKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:10:54 -0500
Message-ID: <1329865848.18384.64.camel@edumazet-laptop>
Subject: Re: Linux 3.3-rc4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Date: Wed, 22 Feb 2012 00:10:48 +0100
In-Reply-To: <CA+55aFxkbsZN3yG6d9DPGiXmiuX-wOURJcC0hAUN3Qbykv1UhQ@mail.gmail.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
	 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
	 <CA+55aFxkbsZN3yG6d9DPGiXmiuX-wOURJcC0hAUN3Qbykv1UhQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 21 février 2012 à 14:43 -0800, Linus Torvalds a écrit :
> On Sun, Feb 19, 2012 at 5:42 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
> >
> > 2.) while debugging above issue: I did find an minor bug in sys_poll() - nobody did take care of my proposed patch: https://lkml.org/lkml/2011/9/24/35
> 
> Ok, so I started out forward-porting that patch to current -git
> (trivial: it's just that the system call tables are differently
> generated now), but the more I look at it, the more I suspect that we
> should perhaps just globally fix "sys_poll()" to have the timeout
> argument be 'int'.
> 
> Because that *is* the standard user interface (just do "man 2 poll"),
> and while all of the git history (and all of the BK history) we've had
> it as "long", I suspect we should just fix it.
> 
> So I suspect the correct patch is just as attached instead: make
> sys_poll() just take an "int timeout". Any user who tried to use a
> long value would already have got truncated by glibc - I just checked.
> 
> Of course, there is a remote possibility that somebody might not use
> glibc, and have used "poll()" with the raw system call interface, and
> depended on using a 64-bit "long timeout" on 64-bit architectures.
> 
> But quite frankly, that sounds rather unlikely in the extreme.
> 
> Comments? If we do this, and somebody actually reports that they use a
> 64-bit timeout, we could always go back to the broken 'long' argument,
> and take your patch to fix the compat case.
> 
>                   Linus

Yep, this is what I thought, but when this was raised last september,
both Andrew and Andi disagreed.

https://lkml.org/lkml/2011/10/6/389



