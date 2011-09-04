Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1IDRJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 13:09:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab1IDRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 13:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <3546423.kFMPx0aPCi@wuerfel>
References: <4E582577.2060805@zytor.com> <19229.1315070217@turing-police.cc.vt.edu>
 <4E62638E.40308@zytor.com> <3546423.kFMPx0aPCi@wuerfel>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 4 Sep 2011 10:08:50 -0700
Message-ID: <CA+55aFwmu8kqdMLK_wLbvKCqCbkS2AXOd7fBvupVcgzkcaC88Q@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
        "H.J. Lu" <hjl.tools@gmail.com>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 4, 2011 at 8:17 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> For a lot of these cases, the best option is to change the
> kernel headers to use new definitions on x32 before someone
> tries to ship a distro, especially when the ioctl command code
> is fixed. In case of the XFS ioctls, I think the only sane
> way is define the x32 ABI to match the 64 bit ABI completely,
> while for RAW_GETBIND and VIDEO_GET_EVENT it's probably enough
> to make x32 match x86-32.

Ack, ack, ack.

If we make the x32 ioctl system call first do "regular" ioctl, and
then fall back to the compat ones if that fails, x32 can mix and
match. It's not pretty, but I think it's better than the alternative
(which would be to have to use one r the other and add lots of new
compat handling).

Of course, we could also just have "compat_ioctl()" fall back to
native mode in general, and not make a x32 special case.

                     Linus
