Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406Ab2D0Umi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:42:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40250 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760645Ab2D0Umg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:42:36 -0400
Message-ID: <4F9B049B.2000009@zytor.com>
Date: Fri, 27 Apr 2012 13:42:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michael Tokarev <mjt@tls.msk.ru>,
        Linux-kernel <linux-kernel@vger.kernel.org>, autofs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru> <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com> <4F9A6ABA.6050503@msgid.tls.msk.ru> <CA+55aFwud1nXRr+HpzH8rSkEWcZ_rJmoE7UtQt76D=A3qcb6GQ@mail.gmail.com>
In-Reply-To: <CA+55aFwud1nXRr+HpzH8rSkEWcZ_rJmoE7UtQt76D=A3qcb6GQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 11:19 AM, Linus Torvalds wrote:
> 
> Btw, the whole autofs protocol is *full* of stuff like this. I just
> looked at some other places where the automount daemon does reads of
> fixed sizes, and one of them is a "sizeof(enum states)". Doing a
> sizeof() on an enum is a f*cking bad idea - it's not very well-defined
> at all (different compilers will consider the enum different sizes -
> seriously). But at least that one seems to be something that is purely
> internal to autofs - but it does show that the people involved did not
> think through and design the protocols they used in general - more of
> these kinds of "random sizes of random data structures that we don't
> understand".
> 

The really *really* damning thing with the v5 structure is that it
padded out the whole structure so it wouldn't have to do two read()
operations.  There is a header with a length field in it (which is still
there), and the daemon just ignores it...

	-hpa


P.S. This can still be fixed in user space, by reading the shorter
length, and then eating any additional zeroes.  The kernel does zero out
the extra pad.

