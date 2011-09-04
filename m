Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1IDUN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 16:13:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36043 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab1IDUNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 16:13:23 -0400
Message-ID: <4E63DB86.2090404@zytor.com>
Date: Sun, 04 Sep 2011 13:11:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "H.J. Lu" <hjl.tools@gmail.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <3546423.kFMPx0aPCi@wuerfel> <CAMe9rOqJoy=S4-=tZXrti7w_GtSqaTgX9i69FR92Tv6pPfSDRQ@mail.gmail.com> <1914350.DTEPrFeNfA@wuerfel>
In-Reply-To: <1914350.DTEPrFeNfA@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
>> #define __NR_x32_ioctl
> 
> What do you plan to do for ioctl? Does this mean you want to
> have a third file_operations pointer besides ioctl and compat_ioctl?
> I would hope that you manage this by using different ioctl command
> numbers in the few cases where the x32 version has to differ from
> the x86-32 data structure.
> 

This *should* just be an entry for compat_ioctl in the x86-64 system
call table (as opposed to the i386 system call table.)

>> #define __NR_x32_readv
>> #define __NR_x32_writev
>> #define __NR_x32_preadv
>> #define __NR_x32_pwritev
>> #define __NR_x32_vmsplice
>> #define __NR_x32_move_pages
>> #define __NR_x32_execve
>> #define __NR_x32_set_robust_list
>> #define __NR_x32_get_robust_list
>> #define __NR_x32__sysctl
>> #define __NR_x32_kexec_load
>> #define __NR_x32_times
> 
> I guess you could define the x32 iovec etc. to be compatible with the
> 64 bit one, but that's not a major thing. Why can't you use the
> regular x86_32 calls here?

They still need to be bound to x86-64 system call entry points.  (Well,
in theory they could be invoked via int $0x80, but that is ugly in a
whole lot of ways.)

>> #define __NR_x32_recvfrom
>> #define __NR_x32_sendmsg
>> #define __NR_x32_recvmsg
>> #define __NR_x32_recvmmsg
>> #define __NR_x32_sendmmsg
> 
> These today use the MSG_CMSG_COMPAT flag to distinguish native and compat
> calls. Do you plan to have another flag here to handle cmsg time values?
> 
> What about things like mq_{get,set}attr, quotactl and semtimedop?

	-hpa

