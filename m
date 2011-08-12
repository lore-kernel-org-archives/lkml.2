Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1HLV4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:56:00 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:53818 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab1HLVz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:55:57 -0400
Message-ID: <4E45A16B.9060007@orcon.net.nz>
Date: Sat, 13 Aug 2011 09:55:55 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Sergei Trofimovich <slyfox@gentoo.org>
CC: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH v2] Alpha: unbreak osf_setsysinfo(SSI_NVPAIRS, [SSIN_UACPROC,
 UAC_SIGBUS])
References: <1313182881-21266-1-git-send-email-slyfox@gentoo.org>
In-Reply-To: <1313182881-21266-1-git-send-email-slyfox@gentoo.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Sat, 13 Aug 2011 09:55:55 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Aug 13 09:55:55 2011
X-DSPAM-Confidence: 0.9936
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/11 09:01, Sergei Trofimovich wrote:
> The bug was accidentally found by the following program:
>     #include <asm/sysinfo.h>
>     #include <asm/unistd.h>
>     #include <sys/syscall.h>
>     static int setsysinfo(unsigned long op, void *buffer, unsigned long size,
>                           int *start, void *arg, unsigned long flag) {
>         return syscall(__NR_osf_setsysinfo, op, buffer, size, start, arg, flag);
>     }
> 
>     int main(int argc, char **argv) {
>         short x[10];
>         unsigned int buf[2] = { SSIN_UACPROC, UAC_SIGBUS, };
>         setsysinfo(SSI_NVPAIRS, buf, 1, 0, 0, 0);
> 
>         int  *y = (int*) (x+1);
>         *y = 0;
>         return 0;
>     }
> 
> The program shoud fail on SIGBUS, but didn't.
> 
> The patch is a second part of userspace flag fix:
>> commit 745dd2405e281d96c0a449103bdf6a895048f28c
>> Author: Michael Cree <mcree@orcon.net.nz>
>> Date:   Mon Nov 30 22:44:40 2009 -0500
>>
>>    Alpha: Rearrange thread info flags fixing two regressions
>>
>>    Both regressions fixed by (1) rearranging TIF_NOTIFY_RESUME flag to be
>>    in lower 8 bits of the thread info flags, and (2) making sure that
>>    ALPHA_UAC_SHIFT matches the rearrangement of the thread info flags.
> 
> Deleted outdated out-of-sync 'UAC_SHIFT' (the cause of bug) in favour of 'ALPHA_UAC_SHIFT'.
> 
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> Cc: linux-alpha@vger.kernel.org
> Cc: Michael Cree <mcree@orcon.net.nz>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> ---
>  arch/alpha/include/asm/sysinfo.h     |    9 ---------
>  arch/alpha/include/asm/thread_info.h |    8 ++++----
>  arch/alpha/kernel/osf_sys.c          |    7 ++++---
>  3 files changed, 8 insertions(+), 16 deletions(-)

Looks good to me.

Acked-by: Michael Cree <mcree@orcon.net.nz>

Thanks
Michael.
