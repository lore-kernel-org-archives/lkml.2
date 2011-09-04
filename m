Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1IDTHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 15:07:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1IDTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 15:07:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
Date: Sun, 04 Sep 2011 21:06:48 +0200
Message-ID: <1914350.DTEPrFeNfA@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CAMe9rOqJoy=S4-=tZXrti7w_GtSqaTgX9i69FR92Tv6pPfSDRQ@mail.gmail.com>
References: <4E582577.2060805@zytor.com> <3546423.kFMPx0aPCi@wuerfel> <CAMe9rOqJoy=S4-=tZXrti7w_GtSqaTgX9i69FR92Tv6pPfSDRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ecnfjIJwMS54+IU0B20330Zf5Y/1eNIttqVaWXqlKXm
 bi3qmA8m+aqsEmqsaoqhRleVuQwiLhUoGdhwEaUgV4QSJgfIfp
 CZ/dckvZjadkGfbHM4tJBdOhoM2TDgfO3T51jdMGwuvNlCijgg
 oyd/AAhSflmzHXR1yE0twQipNYyVT9T9XzdzDvpUHE0kqfo7R5
 nA/iQkNw0RvfoVN7u5BWLvRA4sDb2R+9EBPUuD53NeV4SxBjQN
 o427OgsGgjnvsSg6hS4bXAjn5fvB14W53fIWMwEHSRU0tMDygd
 eA3w72KpW24GAd7TNJn/ekYOhzuzDDvYuamiF53RML9LFdrrOp
 ZgLXrYEe5MfE3ReWPk3Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 September 2011 11:40:39 H.J. Lu wrote:
> #define __NR_x32_rt_sigaction
> #define __NR_x32_rt_sigprocmask
> #define __NR_x32_rt_sigreturn
> #define __NR_x32_rt_sigpending
> #define __NR_x32_rt_sigtimedwait
> #define __NR_x32_rt_sigqueueinfo
> #define __NR_x32_rt_tgsigqueueinfo
> #define __NR_x32_sigaltstack
> #define __NR_x32_waitid
> #define __NR_x32_mq_notify
> #define __NR_x32_timer_create

Right, all signal functions certainly need a new implementation.

> #define __NR_x32_ioctl

What do you plan to do for ioctl? Does this mean you want to
have a third file_operations pointer besides ioctl and compat_ioctl?
I would hope that you manage this by using different ioctl command
numbers in the few cases where the x32 version has to differ from
the x86-32 data structure.

> #define __NR_x32_readv
> #define __NR_x32_writev
> #define __NR_x32_preadv
> #define __NR_x32_pwritev
> #define __NR_x32_vmsplice
> #define __NR_x32_move_pages
> #define __NR_x32_execve
> #define __NR_x32_set_robust_list
> #define __NR_x32_get_robust_list
> #define __NR_x32__sysctl
> #define __NR_x32_kexec_load
> #define __NR_x32_times

I guess you could define the x32 iovec etc. to be compatible with the
64 bit one, but that's not a major thing. Why can't you use the
regular x86_32 calls here?

> #define __NR_x32_recvfrom
> #define __NR_x32_sendmsg
> #define __NR_x32_recvmsg
> #define __NR_x32_recvmmsg
> #define __NR_x32_sendmmsg

These today use the MSG_CMSG_COMPAT flag to distinguish native and compat
calls. Do you plan to have another flag here to handle cmsg time values?

What about things like mq_{get,set}attr, quotactl and semtimedop?

	Arnd
