Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab2E3VEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:04:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42449 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2E3VEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:04:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120530205612.GY11775@ZenIV.linux.org.uk>
References: <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk> <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <20120516021828.GP22082@ZenIV.linux.org.uk> <1337807899.15138.31.camel@falcor>
 <20120530043443.GA3200@ZenIV.linux.org.uk> <20120530163605.GV11775@ZenIV.linux.org.uk>
 <1338406967.2257.24.camel@localhost> <20120530202427.GW11775@ZenIV.linux.org.uk>
 <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com> <20120530205612.GY11775@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 May 2012 14:04:23 -0700
X-Google-Sender-Auth: frfOnQzAFpjmOFvsihDlo0vgWGg
Message-ID: <CA+55aFwXfD6vCj8sHuB33ctB-D8cfJN45h+iURXA6mR=S0mgwA@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 1:56 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> It actually cleaned things up, and made the calling conventions
>> simpler. Just always pass in "reqprot", and have the security layer do
>> the trivial "calculate final prot".
>
> If only it would be trivial ;-/  Take a look at !MMU case (or at the
> description in the posting upthread if you want to avoid seeing your
> breakfast one more time - the code in validate_mmap_request() is
> really ugly).

Don't bother with validate_mmap_request() for nommu. It's ugly, but it
does the same thing, and if it does something else, it's buggy anyway.

Generating 'prot' from 'reqprot' really *should* be as simple as what
I did in my patch. The fact that some places f*ck it up is their
problem - see for example mprotect (I think) that didn't take
MNT_NOEXEC into account.

Don't try to emulate those broken semantics. Just fix them.

                Linus
