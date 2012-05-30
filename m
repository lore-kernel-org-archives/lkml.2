Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2E3U2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:28:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54941 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2E3U2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:28:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120530202427.GW11775@ZenIV.linux.org.uk>
References: <1337112446.20904.50.camel@falcor> <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk> <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <20120516021828.GP22082@ZenIV.linux.org.uk> <1337807899.15138.31.camel@falcor>
 <20120530043443.GA3200@ZenIV.linux.org.uk> <20120530163605.GV11775@ZenIV.linux.org.uk>
 <1338406967.2257.24.camel@localhost> <20120530202427.GW11775@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 May 2012 13:28:09 -0700
X-Google-Sender-Auth: -67fgSssUJ7LZIe6PnUV7ZAkW2E
Message-ID: <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 1:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, May 30, 2012 at 03:42:47PM -0400, Eric Paris wrote:
>> security_file_mmap() would pretty much only be used in do_mmap_pgoff()
>> (or validate_mmap_request)
>
> Callers, actually - the whole point is to lift it out of under ->mmap_sem.
> The tricky part is reqprot vs. prot mess.

See how I solved reqprot vs prot in my suggested original patch. You
have it somewhere in your inbox, I know, because you called me out on
the fact that my original email forgot to attach it ;)

It actually cleaned things up, and made the calling conventions
simpler. Just always pass in "reqprot", and have the security layer do
the trivial "calculate final prot".

Anyway, my original patch worked, but it (incorrectly) optimized away
the call to the security layer if file was NULL. But that's just a
matter of removing that check.

                  Linus
