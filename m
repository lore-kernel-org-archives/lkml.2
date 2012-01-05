Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2AERtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:49:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40698 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2AERtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:49:20 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1325762522.3635.23.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	<1325610682-24811-2-git-send-email-olof@lixom.net>
	<1325762522.3635.23.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Thu, 5 Jan 2012 09:49:19 -0800
Message-ID: <CAOesGMgVty61Wgzv1kQWWc+jwqa7q__bPiRe4Pt2PvM4qfYgZg@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86: efi: refactor efi_init() a bit
From: Olof Johansson <olof@lixom.net>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 3:22 AM, Matt Fleming <matt.fleming@intel.com> wrote:
> On Tue, 2012-01-03 at 09:11 -0800, Olof Johansson wrote:
>> Break out some of the init steps into helper functions.
>>
>> No code changes at all, identical execution flow.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> ---
>>  arch/x86/platform/efi/efi.c |   89 +++++++++++++++++++++++++++----------------
>>  1 files changed, 56 insertions(+), 33 deletions(-)
>
> Makes sense. I've got one tiny comment below, but other than that feel
> free to add,
>
> Acked-by: Matt Fleming <matt.fleming@intel.com>
>
>>       if (memmap.desc_size != sizeof(efi_memory_desc_t))
>> -             printk(KERN_WARNING
>> -               "Kernel-defined memdesc doesn't match the one from EFI!\n");
>> +             printk(KERN_WARNING "Kernel-defined memdesc doesn't match the "
>> +                    "one from EFI!\n");
>
> This sort of thing is generally discouraged because splitting a printk
> string across more than one line makes it harder to grep for. I'm not
> sure this hunk is an improvement.

Agreed, and in this particular case it was just churn.

I've taken a couple of liberties with the 80-character limit instead
in the revised patch set. For the ones that would go way above 80 I
still broke them in two lines though.


Thanks,

-Olof
