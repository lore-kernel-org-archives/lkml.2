Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760467Ab2DKOw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:52:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64877 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760359Ab2DKOwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:52:24 -0400
MIME-Version: 1.0
In-Reply-To: <m21unuoch5.fsf@igel.home>
References: <1334016417-18748-1-git-send-email-ddaney.cavm@gmail.com>
 <20120411070332.6F3C03E081E@localhost> <m21unuoch5.fsf@igel.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 Apr 2012 08:52:03 -0600
X-Google-Sender-Auth: 7WAR0qmqtGGjkdzBNQgH8sNJJHM
Message-ID: <CACxGe6sDcqu6TcS9ZYYeNffMdUrH0_SVou37H83qzM8mKAGV_A@mail.gmail.com>
Subject: Re: [PATCH] iqrdomain: Improve formatting in debugfs.
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 3:16 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Grant Likely <grant.likely@secretlab.ca> writes:
>
>> @@ -667,7 +667,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
>>                       seq_printf(m, "%-15s  ", p);
>>
>>                       data = irq_desc_get_chip_data(desc);
>> -                     seq_printf(m, "0x%16p  ", data);
>> +                     seq_printf(m, data ? "0x%p  " : "  %p  ", data);
>
> You should be able to use %#p instead to let it add the prefix.

That mostly works, but it doesn't round up the field size to account
for the 2 characters in '0x'.  Looks like the %p code needs to be
tweaked to fix that.

Also, gcc complains about it:

/home/grant/hacking/linux/kernel/irq/irqdomain.c: In function ‘virq_debug_show’:
/home/grant/hacking/linux/kernel/irq/irqdomain.c:670:4: warning: '#'
flag used with ‘%p’ gnu_printf format [-Wformat]

Do you know how to suppress that?
