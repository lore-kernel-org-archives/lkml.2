Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2C1Ajw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:39:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34072 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2C1Aju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAMzpN2juEfBPcq-wKsMOG1v3ii9PNCPW6y+sT-XXAPf1jdAvkw@mail.gmail.com>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
 <CABS55+D97mKFdQhGdAXjMGfyRiWd4Os8wfRq9YNa-FQAEQSR7Q@mail.gmail.com>
 <CA+55aFyVELrXO50pfbL-eH48K3_3noRkKMDCqTSVsuSQ0hHRWw@mail.gmail.com>
 <CAMzpN2hqay2h111C6pWw6VEBMLDfO_UF-Xf41M1x5ewp5K90yw@mail.gmail.com>
 <20120327050238.GA19496@redhat.com> <CAMzpN2juEfBPcq-wKsMOG1v3ii9PNCPW6y+sT-XXAPf1jdAvkw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Mar 2012 17:39:28 -0700
X-Google-Sender-Auth: 5hYj6uxNCb1pj542S8_vrhBoys4
Message-ID: <CA+55aFzq8NZ9rr9W7JU6MrkQkFaFdHWKGPMs0ABYSjawS-m4ig@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
To: Brian Gerst <brgerst@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Jason Garrett-Glaser <jason@x264.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:31 PM, Brian Gerst <brgerst@gmail.com> wrote:
>
> Yes, I see that commit.  It looks like I have a different bug that is
> preventing the current head from booting then.  Bisecting brought me
> to this commit instead.

So try first just forcing DCACHE_WORD_ACCESS off (easily done by just
removing the "select" line in arch/x86/Kconfig).

If that fixes things, it really is the word access code.

But if the problem persists and it's a different bug, try to bisect it
with that DCACHE_WORD_ACCESS config option always forced off, just to
avoid any mixing of issues, exactly because we did have that one bug
that already got fixed that looked somewhat similar..

I'll test the current -git kernel on a F16 machine I have, just to
check. But I'm also assuming that there is something specific about
your setup, because otherwise I'd have expected many  more reports
about this...

                     Linus
