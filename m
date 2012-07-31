Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2GaUKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:10:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35142 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab2GaUKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120731191731.GB30493@redhat.com>
References: <20120731191731.GB30493@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 31 Jul 2012 13:10:19 -0700
X-Google-Sender-Auth: OGHDnBoBnfui_4WlnKZa1tQhfeI
Message-ID: <CA+55aFzDcnq3kB6zD7P+A7fizbSo-YZwUTiBs6JyO9GQxsYfFg@mail.gmail.com>
Subject: Re: post 3.5, phantom signals.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 12:17 PM, Dave Jones <davej@redhat.com> wrote:
> Since 3.5, I've started noticing weird things happening with signal delivery.
> Things I've seen so far..
>
> - long running tasks SIGINT, even though I wasn't even anywhere near the keyboard.
> - processes running inside screen/tmux disappearing (and taking the whole session with them).

I can't even *begin* to guess how something like that could happen due
to kernel issues.

The signals you see are TTY signals, but SIGINT/HUP really don't make
sense as a tty layer bug either. If it was *just* SIGHUP I'd think it
was some tty refcounting issue, but with different signals that sounds
very very unlikely.

Quite frankly, from those symptoms I'd suspect the terminal program
being confused over a kernel issue. Of course, it could be a kernel
change that in turn confuses a terminal program.

             Linus
