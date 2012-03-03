Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab2CCASV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 19:18:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32915 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab2CCAST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 19:18:19 -0500
MIME-Version: 1.0
In-Reply-To: <20120303000203.GH22215@thunk.org>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org> <20120303000203.GH22215@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Mar 2012 16:17:58 -0800
X-Google-Sender-Auth: YbHnvr20RFrDLQND9ohozZ7KT3E
Message-ID: <CA+55aFzp+VhnyLzafboy3ABSV5rTwktMTJthii-S_RT9Z75vKQ@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 4:02 PM, Ted Ts'o <tytso@mit.edu> wrote:
> Stupid question.  Your patch requires unaligned accesses to not have a
> heavy penalty, right?  Wasn't it the case that some generations of x86
> had pretty large penalties for aligned accesses?  Is that something we
> need to worry about?

There are basically no x86's with heavy penalties.

Sure, unaligned accesses are often *slightly* more expensive,
especially if they cross the cache access boundary (which tends to be
8 bytes on older 32-bit cpu's, and generally 16 bytes on more modern
CPUs - so it's not that they are unaligned per se, but that they cross
the bank size). But even then, it's usually not a huge deal (ie it
takes up two read slots instead of just one).

There are x86 chips that are extremely bad at unaligned SSE/MMX
accesses, but not regular words.

                      Linus
