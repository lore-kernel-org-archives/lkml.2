Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1ICDFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 23:05:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303Ab1ICDFu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 23:05:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAMe9rOrPhCC97KV+7AO-z66XJ9R0gidTmRSLZdAOCYjGkJEdFQ@mail.gmail.com>
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de>
 <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de>
 <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com>
 <CAMe9rOpGxNWD=gdvyVpi7V7BrwwWrpLTWdkmTjPqJ1+SUvhA0A@mail.gmail.com> <CAMe9rOrPhCC97KV+7AO-z66XJ9R0gidTmRSLZdAOCYjGkJEdFQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Sep 2011 20:04:49 -0700
Message-ID: <CA+55aFyBtp-iyexHy4ccTy-qW7KqCccFfSD5HzMD_9BaXT-wjg@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 7:56 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
>
> We need to make decision on some system calls which take a pointer
> to structure with long.  For example, msg calls take a pointer to
>
>          struct msgbuf {
>               long mtype;       /* message type, must be > 0 */
>               char mtext[1];    /* message data */
>           };
>
> We have 3 choices:
>
> 1. Use long long for x32 and use 64bit msg system calls.

I think this sounds like the best option. As many plain 64-bit system
calls as humanly possible.

                Linus
