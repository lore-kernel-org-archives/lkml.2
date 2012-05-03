Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab2ECPuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:50:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34976 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2ECPuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:50:51 -0400
Message-ID: <4FA2A8DC.10905@linaro.org>
Date: Thu, 03 May 2012 08:48:44 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
References: <cover.1335510125.git.richardcochran@gmail.com> <4F9B228F.90903@linaro.org> <20120428080443.GA2241@netboy.at.omicron.at> <4F9EFC70.50405@linaro.org> <20120503070139.GA2235@netboy.at.omicron.at>
In-Reply-To: <20120503070139.GA2235@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050315-3270-0000-0000-00000609DF6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 12:02 AM, Richard Cochran wrote:
> On Mon, Apr 30, 2012 at 01:56:16PM -0700, John Stultz wrote:
>> No. So, on architectures that support vsyscalls/vdso (x86_64,
>> powerpc, ia64, and maybe a few others) getnstimeofday() is really
>> only an internal interface for in-kernel access. Userland uses the
>> vsyscall/vdso interface to be able to read the time completely from
>> userland context (with no syscall overhead). Since this is done in
>> different ways for each architecture, you need to export the proper
>> information out via update_vsyscall() and also update the
>> arch-specific vsyscall gettimeofday paths (which is non-trivial, as
>> some arches are implemented in asm, etc - my sympathies here, its a
>> pain).
> Okay, so now I understand the vDSO page thingy. Help me please to
> understand exactly which architectures would need changes for my
> proposal.
>
> The only archs exporting time variables/functions through vDSO are
> those which define CONFIG_GENERIC_TIME_VSYSCALL=y, namely:
>
> - ia64
> - powerpc 64 and 32 bit
> - s390    64 and 32 bit
> - x86     64 bit only **
>
>    ** But 32 guest running in a 64 host also has time in the vDSO?!?
   Yes, but at least on x86 its just one implementation that needs to be 
modified.

>
> Did I get that right?
That looks right to me.

thanks
-john

