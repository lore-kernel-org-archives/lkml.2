Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1IETfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:35:02 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33522 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1IETez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <201109051921.59776.arnd@arndb.de>
References: <4E582577.2060805@zytor.com>
	<2722845.TegCUU4bu0@wuerfel>
	<CAMe9rOo2JdzerzfTAFER8rZEOGZkp6HxstdT4_3_s0x6UwTPow@mail.gmail.com>
	<201109051921.59776.arnd@arndb.de>
Date: Mon, 5 Sep 2011 12:34:54 -0700
Message-ID: <CAMe9rOpYy5Y27G7anE82+_udYUf6JGA3N=hZdnf_FieLkRXdBA@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
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

On Mon, Sep 5, 2011 at 10:21 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 05 September 2011, H.J. Lu wrote:
>> I added MSG_CMSG_COMPAT64 and new compat system calls with
>> 64bit timespec/val to support it.  See the enclosed patch.
>
> Yes, looks good. Maybe there should be an #ifdef in there though,
> so the other compat architectures don't get the extra code.
>
>> BTW, I also added
>>
>> compat_sys_preadv64(unsigned long fd, const struct compat_iovec __user *vec,
>>          unsigned long vlen, loff_t pos)
>> compat_sys_pwritev64(unsigned long fd, const struct compat_iovec __user *vec,
>>          unsigned long vlen, loff_t pos)
>>
>> to support 32bit compat_iovec * and 64bit offset.
>
> Does that make much of a difference? I would guess that it's just as
> easy to do in libc by splitting the pos argument and calling the
> existing compat_sys_preadv. Alternatively, you could make glibc
> copy the iovec array to the 64 bit format and call the native syscall,
> because compat_rw_copy_check_uvector() otherwise just ends up doing that
> in kernel space. Or you just define the x32 libc iovec to
>
> struct iovec {
>        void *iov_base;
>        unsigned int __pad; /* gets cleared by libc */
>        __u64 iov_len;
> }
>

I need to clear __pad for every readv/writev/preadv/pwritev call
even if it has been cleared before.  Is compat_sys_xxx faster
than this?


-- 
H.J.
