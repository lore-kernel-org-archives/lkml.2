Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab0JFX1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:27:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64687 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0JFX1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 19:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EPVZ54TcThDue7Mfh0QmcwNUurqPmWh7D9uvZsezpfuXpaCh+ml9l1LC8PxFi+810v
         r6ENxoT07zyXLzjU9UxPgm4YsjkdZbHNyozDKoJPabo6I+cd+UOFDCjhcyKMJZ/E8JXR
         1yoQ1LVvgb6EPSM5VKRLUVk0fDqNAKKdlcisk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010070058220.17015@localhost6.localdomain6>
References: <AANLkTik0q3i9SkydhJFbousVrHbc+eMM2SkaxR4MD41U@mail.gmail.com>
	<alpine.LFD.2.00.1010070058220.17015@localhost6.localdomain6>
Date: Thu, 7 Oct 2010 02:27:45 +0300
Message-ID: <AANLkTik++Rb-x+aLtKv83USqSn8tQ4iyfSyWCNgfM+nO@mail.gmail.com>
Subject: Re: twl4030 irq crashes
From: Grazvydas Ignotas <notasas@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 1:59 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 7 Oct 2010, Grazvydas Ignotas wrote:
>
>> Hello,
>>
>> I've pulled today's (20101006) linux-next and twl4030 started crashing
>> on certain interrupts. twl4030 irq code hasn't changed so it's
>> probably genirq's fault:
>>
>> [    0.889739] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000000
>> [    0.898193] pgd = c0004000
>> [    0.901000] [00000000] *pgd=00000000
>> [    0.904754] Internal error: Oops: 80000005 [#1]
>> [    0.909484] last sysfs file:
>> [    0.912567] Modules linked in:
>> [    0.915771] CPU: 0    Not tainted
>> (2.6.36-rc6-next-20101006-00001-g766a681-dirty #205)
>> [    0.924133] PC is at 0x0
>> [    0.926788] LR is at handle_edge_irq+0x84/0x14c
>
> Can you please decode that line with
>
> addr2line -e vmlinux c0077244

kernel/irq/chip.c:725
