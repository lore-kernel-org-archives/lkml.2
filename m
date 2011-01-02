Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1ABLGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 06:06:30 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50388 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab1ABLG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 06:06:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EDidNeWDLx6yHwIMzy4LkV2P3Awx0x67UQZHhqYR+T6ytWYW/l8XSodgVpHdx6pxko
         uZQv6ajX1DptlL7A2aHU0ypYZN8N2lyFd33mR80BUYKhP7+kz3nGfifQM45uDx64EyuN
         P8Qk5pXZZ0dJkS2ZdFzlbLLjUIEyss1rMCzz8=
MIME-Version: 1.0
In-Reply-To: <20101221233942.GL1263@parisc-linux.org>
References: <20101221233942.GL1263@parisc-linux.org>
Date: Sun, 2 Jan 2011 12:06:28 +0100
X-Google-Sender-Auth: eowAO5ES--iYwcjHEqNtQAxI-Io
Message-ID: <AANLkTikJu1saccQ6XB3KwCw-1XMR0+j5aDwp_HNFYpf2@mail.gmail.com>
Subject: Re: [PATCH] Prevent users from disabling tickless
From: Remy Bohmer <linux@bohmer.net>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/12/22 Matthew Wilcox <matthew@wil.cx>:
>
> Disabling NO_HZ has a serious negative effect on performance -- an extra
> 70us per I/O.  Prevent users from deselecting it.

Enabling NO_HZ has a serious negative effect on realtime due to longer
interrupt handling and less predictability of the system.
We prefer to align the timer interrupt handling to the interrupt
handling of our realtime control loops so they do not bother each
other. A varying moment of the timer interrupt handling would destroy
much realtime responsiveness here.

So, what is good for throughput is usually bad for responsiveness...

This is an example that the many different applications of the Linux
kernel demand a different configuration of the kernel.
I prefer to keep it configurable.

Kind regards,

Remy
