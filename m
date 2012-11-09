Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab2KIJvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:51:14 -0500
Received: from multi.imgtec.com ([194.200.65.239]:54483 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab2KIJvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:51:09 -0500
Message-ID: <509CD1D1.3050105@imgtec.com>
Date: Fri, 9 Nov 2012 09:50:09 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>
Subject: Re: [RFC PATCH v1 14/31] ARC: syscall support
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-15-git-send-email-vgupta@synopsys.com> <201211071421.39523.arnd@arndb.de>
In-Reply-To: <201211071421.39523.arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_11_09_09_51_07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/12 14:21, Arnd Bergmann wrote:
> On Wednesday 07 November 2012, Vineet Gupta wrote:
>> + * Being uClibc based we need some of the deprecated syscalls:
>> + * -Not emulated by uClibc at all
>> + *     unlink, mkdir,... (needed by Busybox, LTP etc)
>> + *     times (needed by LTP pan test harness)
>> + * -Not emulated efficiently
>> + *     select: emulated using pselect (but extra code to chk usec > 1sec)
>> + *
>> + * some (send/recv) correctly emulated using (recfrom/sendto) and
>> + * some arch specific ones (fork/vfork)can easily be emulated using clone but
>> + * thats the price of using common-denominator....
>> + */
>> +#define __ARCH_WANT_SYSCALL_NO_AT
>> +#define __ARCH_WANT_SYSCALL_NO_FLAGS
>> +#define __ARCH_WANT_SYSCALL_OFF_T
>> +#define __ARCH_WANT_SYSCALL_DEPRECATED
> 
> I'm pretty sure that this has been solved before, best get in contact with
> the maintainers of the openrisc/c6x/hexagon platforms, that probably all
> use uClibc without needing these.
> 
> You have to remove the legacy calls here.

Hi Vineet,

FYI, we'll soon be making some uClibc patches available so that it can
work without these deprecated syscalls and with the newer IPC interface
(the work was needed for metag too). It's based roughly on the OpenRisc
patches from last year, but with a fair few changes.

Thanks
James

