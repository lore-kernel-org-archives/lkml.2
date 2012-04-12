Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934695Ab2DLUqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:46:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34462 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934676Ab2DLUqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:46:39 -0400
MIME-Version: 1.0
In-Reply-To: <4F873D5F.5020901@gmail.com>
References: <1334016417-18748-1-git-send-email-ddaney.cavm@gmail.com>
 <20120411070332.6F3C03E081E@localhost> <m2k41kycy0.fsf@igel.home> <4F873D5F.5020901@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 12 Apr 2012 14:46:17 -0600
X-Google-Sender-Auth: PACTYQHwt-aPA7xi3XXaHOPfhJE
Message-ID: <CACxGe6uiGhVC-q5WP_DH8P9rak0rQZsaLFf1DWra4AtsCtK05g@mail.gmail.com>
Subject: Re: [PATCH] iqrdomain: Improve formatting in debugfs.
To: David Daney <ddaney.cavm@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 2:38 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 04/12/2012 12:20 PM, Andreas Schwab wrote:
>>
>> Grant Likely<grant.likely@secretlab.ca>  writes:
>>
>>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>>> index 9310a8d..eb05e40 100644
>>> --- a/kernel/irq/irqdomain.c
>>> +++ b/kernel/irq/irqdomain.c
>>> @@ -643,8 +643,8 @@ static int virq_debug_show(struct seq_file *m, void
>>> *private)
>>>        void *data;
>>>        int i;
>>>
>>> -       seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
>>> -                     "chip name", "chip data", "domain name");
>>> +       seq_printf(m, "%-5s  %-7s  %-15s  %-*s  %s\n", "irq", "hwirq",
>>> +                     "chip name", 2 * sizeof(void *) + 2, "chip data",
>>> "domain name");
>>
>>
>> kernel/irq/irqdomain.c:647:9: warning: field width specifier ‘*’ expects
>> argument of type ‘int’, but argument 6 has type ‘long unsigned int’
>> [-Wformat]
>>
>
> My original patch assigned the size to an int variable and then passed that
> to the seq_printf(), thus avoiding this issue.  I suspect something like:
>
> s/2 * sizeof(void *) + 2/(int)(2 * sizeof(void *) + 2)/
>
> Would do the trick.

Yeah, I'll push out a fixup patch.

g
