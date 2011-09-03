Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1ICC4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 22:56:35 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:49533 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab1ICC4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 22:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAMe9rOpGxNWD=gdvyVpi7V7BrwwWrpLTWdkmTjPqJ1+SUvhA0A@mail.gmail.com>
References: <4E582577.2060805@zytor.com>
	<201108301409.27527.arnd@arndb.de>
	<4E5D1153.5030908@zytor.com>
	<201108311814.54906.arnd@arndb.de>
	<CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com>
	<CAMe9rOpGxNWD=gdvyVpi7V7BrwwWrpLTWdkmTjPqJ1+SUvhA0A@mail.gmail.com>
Date: Fri, 2 Sep 2011 19:56:33 -0700
Message-ID: <CAMe9rOrPhCC97KV+7AO-z66XJ9R0gidTmRSLZdAOCYjGkJEdFQ@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
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

On Wed, Aug 31, 2011 at 10:05 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Wed, Aug 31, 2011 at 9:46 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I really think that "x32" should try to aim *VERY* hard at using the
>> 64-bit system calls, and seeing itself as being a "32-bit application
>> in a 64-bit world".  That's not just true for time_t (which I think
>> should be 64-bit on anything new that expects to survive for any
>> amount of time), but in general.
>>
>
> I have been making x32 to use 64bit system calls as much as possible.
> Hopefully, I will get it to work in a week or 2.
>

I have an x32 kernel which usea 64bit time_t/timespec/timeval and file
system interface:

1. Use 64bit system calls as much as we can.
2. There are 32 compat system calls for x32 to support structure parameters
with pointers and longs.
3. Use x86-64 vDSO relocatable files directly to generate x32 vDSO.

We need to make decision on some system calls which take a pointer
to structure with long.  For example, msg calls take a pointer to

          struct msgbuf {
               long mtype;       /* message type, must be > 0 */
               char mtext[1];    /* message data */
           };

We have 3 choices:

1. Use long long for x32 and use 64bit msg system calls.
2. Keep long for x32 and use compat system call.
3. Add a 4byte padding for x32 and sign-extend from mtype to 4byte
padding before passing to 64bit msg system call.

I implemented option 1.  I can also implement option 2 or 3.

Thanks.


-- 
H.J.
