Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab2LNSsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:48:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48920 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab2LNSsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:48:21 -0500
Message-ID: <50CB7459.7010107@zytor.com>
Date: Fri, 14 Dec 2012 10:47:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Pavel Emelyanov <xemul@parallels.com>, aarcange@redhat.com,
        ak@linux.intel.com, Stefani Seibold <stefani@seibold.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        mingo@redhat.com, john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
References: <1355343572-23074-1-git-send-email-stefani@seibold.net> <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e> <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e> <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e> <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com> <50CA6E4C.6000305@zytor.com> <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com> <50CA81A4.9040702@zytor.com> <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com> <50CA85BD.7070502@zytor.com> <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com> <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com> <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com> <50CAE485.5020608@parallels.com> <50CB716D.6020501@zytor.com> <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com>
In-Reply-To: <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 10:44 AM, Andy Lutomirski wrote:
>>
>> mremap() should work.  At the same time, the code itself is not going to
>> have any stability guarantees between kernel versions -- it obviously
>> cannot.
> 
> We could guarantee that the symbols in the vdso resolve to particular
> offsets within the vdso.  (Yes, this is ugly.)
> 
> Does criu support checkpointing with one version of a shared library
> and restoring with another?  If there are no textrels (or whatever the
> relocation type that actually modifies text as opposed to just the plt
> or got) then, in principle, it should be doable.  Otherwise some
> kernel help will be needed to checkpoint reliably on one kernel and
> restore somewhere else.
> 
> (This isn't a regression -- it's already broken.)
> 

The real issue is that happens if the process is checkpointed while
inside the vdso and now eip/rip or a stack frame points into the vdso.
This is not impossible or even unlikely, especially on 32 bits it is
downright likely.

	-hpa

