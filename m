Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283Ab2COOkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:40:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51418 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761115Ab2COOkR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <d2e03d5f063de84d1bae3c3e06296f81.squirrel@webmail.greenhost.nl>
References: <1331781125-15658-1-git-send-email-wad@chromium.org>
	<1331781125-15658-12-git-send-email-wad@chromium.org>
	<d2e03d5f063de84d1bae3c3e06296f81.squirrel@webmail.greenhost.nl>
Date: Thu, 15 Mar 2012 09:40:13 -0500
Message-ID: <CABqD9hZ-i-Aa5+7DTmtQ5JU4EAKQfP=HenqgJeFZ2pftQqoUcg@mail.gmail.com>
Subject: Re: [PATCH v15 11/13] ptrace,seccomp: Add PTRACE_SECCOMP support
From: Will Drewry <wad@chromium.org>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:49 PM, Indan Zupancic <indan@nul.nu> wrote:
> Hi Will,
>
> On Thu, March 15, 2012 04:12, Will Drewry wrote:
>> @@ -73,6 +74,7 @@
>>  #define PTRACE_EVENT_VFORK_DONE      5
>>  #define PTRACE_EVENT_EXIT    6
>>  #define PTRACE_EVENT_STOP    7
>> +#define PTRACE_EVENT_SECCOMP 8
>>
>>  #include <asm/ptrace.h>
>>
>> @@ -101,8 +103,9 @@
>>  #define PT_TRACE_EXEC                PT_EVENT_FLAG(PTRACE_EVENT_EXEC)
>>  #define PT_TRACE_VFORK_DONE  PT_EVENT_FLAG(PTRACE_EVENT_VFORK_DONE)
>>  #define PT_TRACE_EXIT                PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
>> +#define PT_TRACE_SECCOMP     PT_EVENT_FLAG(PTRACE_EVENT_SECCOMP)
>>
>> -#define PT_TRACE_MASK        0x000003f4
>> +#define PT_TRACE_MASK        0x00000ff4
>
> Did you miss this bit?

Kinda.  I'll go ahead and switch it to 0xbf4, but PT_TRACE_MASK
doesn't exist in linux-next so this bit disappears on merge.  However,
it is relevant if people are backporting this code, so I'll push a new
rev of it in a bit if I don't get any other comments (or include it in
the next rev if there are comments).

Thanks!
will
