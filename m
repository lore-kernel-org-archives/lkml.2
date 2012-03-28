Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2C1A4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:56:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36851 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2C1A4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:56:01 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzq8NZ9rr9W7JU6MrkQkFaFdHWKGPMs0ABYSjawS-m4ig@mail.gmail.com>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
	<CABS55+D97mKFdQhGdAXjMGfyRiWd4Os8wfRq9YNa-FQAEQSR7Q@mail.gmail.com>
	<CA+55aFyVELrXO50pfbL-eH48K3_3noRkKMDCqTSVsuSQ0hHRWw@mail.gmail.com>
	<CAMzpN2hqay2h111C6pWw6VEBMLDfO_UF-Xf41M1x5ewp5K90yw@mail.gmail.com>
	<20120327050238.GA19496@redhat.com>
	<CAMzpN2juEfBPcq-wKsMOG1v3ii9PNCPW6y+sT-XXAPf1jdAvkw@mail.gmail.com>
	<CA+55aFzq8NZ9rr9W7JU6MrkQkFaFdHWKGPMs0ABYSjawS-m4ig@mail.gmail.com>
Date: Tue, 27 Mar 2012 20:56:00 -0400
Message-ID: <CAMzpN2hxj5xTDgGP3Gjs4Uxoo69ae1QLeBET7McMgOetkGDKgg@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
From: Brian Gerst <brgerst@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Jason Garrett-Glaser <jason@x264.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 8:39 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Mar 26, 2012 at 10:31 PM, Brian Gerst <brgerst@gmail.com> wrote:
>>
>> Yes, I see that commit.  It looks like I have a different bug that is
>> preventing the current head from booting then.  Bisecting brought me
>> to this commit instead.
>
> So try first just forcing DCACHE_WORD_ACCESS off (easily done by just
> removing the "select" line in arch/x86/Kconfig).
>
> If that fixes things, it really is the word access code.
>
> But if the problem persists and it's a different bug, try to bisect it
> with that DCACHE_WORD_ACCESS config option always forced off, just to
> avoid any mixing of issues, exactly because we did have that one bug
> that already got fixed that looked somewhat similar..
>
> I'll test the current -git kernel on a F16 machine I have, just to
> check. But I'm also assuming that there is something specific about
> your setup, because otherwise I'd have expected many  more reports
> about this...
>
>                     Linus

Commit f132c5be05e40 did fix this particular problem for me.  There is
another bug causing boot failure (seems to be in the DRM code), but
bisecting initially fingered this patch.  It was just looking at
kernels in between this patch and the later fix.  Sorry for the
confusion.

--
Brian Gerst
