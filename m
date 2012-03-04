Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2CDX1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 18:27:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37954 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab2CDX1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 18:27:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.79.229 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120304221915.GA19570@parisc-linux.org>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
 <20120303000203.GH22215@thunk.org> <alpine.DEB.2.02.1203021616040.23477@asgard.lang.hm>
 <CA+55aFw7C3XYzwZ8F31EA4Svj1WZ8O--HV82qVg3t=JpxRy1Ww@mail.gmail.com> <20120304221915.GA19570@parisc-linux.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 4 Mar 2012 15:27:01 -0800
X-Google-Sender-Auth: W3Tk01LBeEDKc_KPYwdRlrUOLks
Message-ID: <CA+55aFwCchGnXPsQEQLrdp1CBphwardJpVF57thjzDddvGxHUQ@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
To: Matthew Wilcox <matthew@wil.cx>
Cc: david@lang.hm, "Ted Ts'o" <tytso@mit.edu>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 4, 2012 at 2:19 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>
> To be fair, that wasn't the ARM core.  That was the MEMC chip (roughly
> equivalent to a northbridge).  Also, there's no need for Linux to care
> about that any more, since we removed the arm26 port in July 2007.  As far
> as I know, all arm32 cores have been coupled with memory controllers
> that are functional.

No, it wasn't just the memory controller.

The ARM cores really did some crazy stuff. Loading an unaligned
pointer resulted in loading the value from the aligned pointer, and
then doing a byte rotate on the result. And it did so silently without
a trap. So you didn't get the right value, *and* you didn't even get a
trap to tell you that the CPU couldn't do it. That's just pure
garbage.

You can call it a "feature", but sane people call it a bug. The fact
that it was *designed* to do that doesn't make it less buggy, it just
makes it sad.

Now, the modern "bigger" ARM cores don't have that problem, but the
small cores still do, afaik.

                   Linus
