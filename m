Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1ICR2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 13:28:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53356 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1ICR2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 13:28:50 -0400
Message-ID: <4E62638E.40308@zytor.com>
Date: Sat, 03 Sep 2011 10:27:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110817 Fedora/3.1.12-1.fc14 Thunderbird/3.1.12
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Arnd Bergmann <arnd@arndb.de>, "H.J. Lu" <hjl.tools@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com> <4E61BB42.4090301@zytor.com> <8179020.mG8hWW8BRr@wuerfel> <14427.1315058668@turing-police.cc.vt.edu>            <9b6a2b8e-365f-4155-85ca-5f72b46a7f3e@email.android.com> <19229.1315070217@turing-police.cc.vt.edu>
In-Reply-To: <19229.1315070217@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2011 10:16 AM, Valdis.Kletnieks@vt.edu wrote:
>>
>> The complexity of changing that would be enormous.
>
> Oh, I know changing the x86-32 ABI is impossible - I meant changing the
> decision to emulate that ABI (as opposed to emulating the x86-64 ABI, or a
> variant thereof, or something else).  Or are we already commited to that
> route, even if we're still trying to figure out what syscalls to include?
>

About ioctl in particular, the ABI has dependencies into almost every 
single driver in the Linux kernel.  It is hard-coded in the kernel that 
there are two paths -- native and compat.  Since pointers are going to 
be 4 bytes, it means we have to use the compat path.

We may be able to cheat a little bit since we encode the argument sizes 
in the ioctl numbers; this solves the case of PPGETTIME/PPSETTIME for 
example (in fact, this ioctl looks currently broken in compat mode!) 
However, at some point the sheer number of data types that can be 
consumed by ioctl is a real concern, so changing the ones we really care 
about -- like timespec/timeval -- while leaving the rest intact so we 
can use the compat path as a general rule would be highly useful.

	-hpa

