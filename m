Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab2BCCAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:00:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35129 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab2BCCAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:00:30 -0500
MIME-Version: 1.0
In-Reply-To: <20120203014533.GT23916@ZenIV.linux.org.uk>
References: <m14nvc82jo.fsf@fess.ebiederm.org> <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <20120202012258.GQ23916@ZenIV.linux.org.uk> <20120202212400.GR23916@ZenIV.linux.org.uk>
 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
 <20120203011612.GS23916@ZenIV.linux.org.uk> <20120203014533.GT23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Feb 2012 18:00:10 -0800
X-Google-Sender-Auth: TL3gptPkt3xiM5nwrhuZQMTdfyA
Message-ID: <CA+55aFxfV0pTqxNN5yV5YsvMVxF2Dir6rwjk-AyRV6s94g10AA@mail.gmail.com>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Becker <jlbec@evilplan.org>, Chris Mason <chris.mason@oracle.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 5:45 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Incidentally, why the hell do we have
>        typedef __kernel_nlink_t        nlink_t;
> anyway?  It's *not* exposed to userland and it's different from the
> userland nlink_t (which is unsigned int on 32bit and unsigned long on 64bit).
> Why not use __kernel_nlink_t (or explicitly-sized __uNN) in
> arch/*/include/asm/stat.h and declare nlink_t kernel-side as __u32?

Probably hysterical raisins, and just converted to the whole
__kernel_nlink_t form together with other, more relevant things.

Feel free to remove it.

> Why do we have daddr_t, while we are at it?  There is exactly one user -
> fs/freevxfs and there we definitely want a fixed-sized type.

I think it's something that probably came from freevxfs and BSD roots
or similar. It's a BSD'ism, afaik.

                    Linus
