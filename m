Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1ICRW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 13:22:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38805 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1ICRWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 13:22:25 -0400
MIME-Version: 1.0
In-Reply-To: <19229.1315070217@turing-police.cc.vt.edu>
References: <4E582577.2060805@zytor.com>
	<CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com>
	<4E61BB42.4090301@zytor.com>
	<8179020.mG8hWW8BRr@wuerfel>
	<14427.1315058668@turing-police.cc.vt.edu>
	<9b6a2b8e-365f-4155-85ca-5f72b46a7f3e@email.android.com>
	<19229.1315070217@turing-police.cc.vt.edu>
Date: Sat, 3 Sep 2011 10:22:23 -0700
Message-ID: <CAMe9rOpdQ=N9pLX13mqigPdDPr0CkEW5+841u4bASicJ4i=b5Q@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Sat, Sep 3, 2011 at 10:16 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sat, 03 Sep 2011 09:40:55 PDT, "H. Peter Anvin" said:
>> Valdis.Kletnieks@vt.edu wrote:
>>
>> >On Sat, 03 Sep 2011 10:41:16 +0200, Arnd Bergmann said:
>> >
>> >(Admittedly, I'm tuning in late on this discussion, but...)
>> >
>> >> For the ioctl interface however, the __u64/__s64 type in the x32 ABI
>> >> must be defined with __attribute__((packed,aligned(4))) to match what
>> >> the kernel implements because it emulates the x86-32 ABI.
>> >
>> >Is this a cast-in-stone issue, or is it still not too late to change that?
>> >And if we change that, can we simplify anything?
>>
>> The complexity of changing that would be enormous.
>
> Oh, I know changing the x86-32 ABI is impossible - I meant changing the
> decision to emulate that ABI (as opposed to emulating the x86-64 ABI, or a
> variant thereof, or something else).  Or are we already commited to that
> route, even if we're still trying to figure out what syscalls to include?

We can't use 64bit ioctl for x32 if indirect pointers are ever passed
to ioctl.


-- 
H.J.
