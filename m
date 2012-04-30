Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab2D3B4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 21:56:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44717 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2D3B4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 21:56:48 -0400
MIME-Version: 1.0
In-Reply-To: <1335749398.2281.0.camel@perseus.themaw.net>
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com>
 <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com>
 <4F9DDCB6.1070908@zytor.com> <CA+55aFwGZm4+rdJ+xArhsVJ8P5gH3xxCfuoHibotr0Sik484=w@mail.gmail.com>
 <4F9DDE47.5060008@zytor.com> <CA+55aFzDhkVzaUYQwKbkUqoRNb223+w0-k=pOxTZHja75JOMvQ@mail.gmail.com>
 <1335749398.2281.0.camel@perseus.themaw.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Apr 2012 18:56:26 -0700
X-Google-Sender-Auth: B9ZHUYR1mOVW9HWiogzd-Z428_Q
Message-ID: <CA+55aFzEefQWk+0EB2+dcL8DZcn+B7=1HZ1MV0HVMX7prhrmVA@mail.gmail.com>
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized pipe
To: Ian Kent <raven@themaw.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Thomas Meyer <thomas@m3y3r.de>, autofs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 6:29 PM, Ian Kent <raven@themaw.net> wrote:
>
> autodir looks ok as well.
>
> http://sourceforge.net/projects/intraperson/files/latest/download

That looks odd, but safe.

Why does the code make the pipe file descriptor non-blocking, when it
then always reads it using that odd "poll_read()" function that does a
loop with poll() and read(). I guess there is some 1-second timeout
thing.

It's a bit odd in other ways too. The "handle_events()" function is
passed the fd, but then it never actually uses it, and uses
'autodir.k_pipe' instead.

So I'm having a bit of trouble following the *logic* to any of that,
but the only reads I found did seem to match the "read whole packet"
model, so it does look ok too.

                     Linus
