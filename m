Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1E2LbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 07:31:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58081 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1E2LbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 07:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sgF6D9Trd9IHf9Fu36tBr06l+/7tp3+sBixs4zzZqsW7+G7lNMcrPn7odFN1bdzil3
         NK6h2q3VqWvWssXfO9i/Mk2A73E8OwJftVEwMuD4BP8RbGVXfqlh6btRw+M4VyNrZZ6m
         Zay/HBV2md8JeM1hNoxZLFfV/rXjyv1xMuH8o=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105290252150.7577@arrandale.kernel.org>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
	<alpine.LFD.2.02.1105290252150.7577@arrandale.kernel.org>
Date: Sun, 29 May 2011 19:31:13 +0800
Message-ID: <BANLkTimpe8MOor+oWm4t0M6ODzM_RPn6yg@mail.gmail.com>
Subject: Re: [PATCH 0/9] ACPI, APEI patches for 2.6.40
From: huang ying <huang.ying.caritas@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 2:55 PM, Len Brown <lenb@kernel.org> wrote:
>> [PATCH 1/9] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
>> [PATCH 2/9] lib, Add lock-less NULL terminated single list
>> [PATCH 3/9] lib, Make gen_pool memory allocator lockless
>> [PATCH 4/9] ACPI, APEI, GHES, printk support for recoverable error via NMI
>
> I think the 4 above should go upstream to enable the
> printk for recoverable errors.  If queuing messages
> from NMI context gets re-implemented in the future,
> then so be it.

The GHES records are queued just for printk.  It has no contradiction
with perf based logging.

> I'll skip the rest, however, except #9:-)
>
> thanks,
> -Len
>
>> [PATCH 5/9] HWPoison: add memory_failure_queue()
>> [PATCH 6/9] ACPI, APEI, GHES: Add hardware memory error recovery support
>> [PATCH 7/9] PCIe, AER, add aer_recover_queue
>> [PATCH 8/9] ACPI, APEI, GHES: Add PCIe AER recovery support
>> [PATCH 9/9] ACPI, APEI, ERST, Prevent erst_dbg from loading if ERST is disabled

I think #5 and #7 just some general code that can be used by perf
based recovering too.  Because we are still waiting for perf based
hardware error logging/recovering infrastructure.  I think we can take
#6 and #8 for now and maybe replace them with perf based solution when
that is ready.

BTW: Can you take a look at another patch with following title?

[PATCH] ACPI, APEI, Add APEI _OSC support

https://lkml.org/lkml/2011/5/25/28

This is needed to enable GHES reporting in firmware on some machines.

Best Regards,
Huang Ying
