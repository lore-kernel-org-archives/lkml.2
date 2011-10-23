Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1JWL33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:29:29 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:58675 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1JWL32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:29:28 -0400
Message-ID: <4EA3FA86.7000905@snapgear.com>
Date: Sun, 23 Oct 2011 21:29:10 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-m68k@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/28 v6] m68k: Convert to genirq
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>	<CAMuHMdWOhKcoDoyTnKJzruZ=gpV5uKNFpXnGCkrac7oEkCihJw@mail.gmail.com> <CAMuHMdX7C5NU5_MO5GdO=Pf2X59B3vFo4Y9B5wg-NQzwVbbLZA@mail.gmail.com>
In-Reply-To: <CAMuHMdX7C5NU5_MO5GdO=Pf2X59B3vFo4Y9B5wg-NQzwVbbLZA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 10/23/2011 07:49 PM, Geert Uytterhoeven wrote:
> On Thu, Oct 20, 2011 at 14:18, Geert Uytterhoeven<geert@linux-m68k.org>  wrote:
>> On Sun, Sep 11, 2011 at 13:59, Geert Uytterhoeven<geert@linux-m68k.org>  wrote:
>>> This patch series converts the m68k/mmu (nommu was converted before)
>>> architecture to the generic hardirq framework.
>>>
>>> á- [01/28] genirq: Add missing "else" in irq_shutdown()
>>> á- [02/28] ide-{cd,floppy,tape}: Do not include<linux/irq.>
>>> á- [03/28] keyboard: Do not include<linux/irq.>
>>> á- [04/28] m68k/irq: Rename irq_controller to irq_chip
>>> á- [05/28] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
>>> á- [06/28] m68k/irq: Rename irq_node to irq_data
>>> á- [07/28] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
>>> á- [08/28] m68k/irq: Rename setup_irq() to m68k_setup_irq() and make it static
>>> á- [09/28] m68k/irq: Extract irq_set_chip()
>>> á- [10/28] m68k/irq: Add m68k_setup_irq_controller()
>>> á- [11/28] m68k/irq: Rename {,__}m68k_handle_int()
>>> á- [12/28] m68k/irq: Remove obsolete IRQ_FLG_* definitions and users
>>> á- [13/28] m68k/irq: Add genirq support
>>> á- [14/28] m68k/atari: Convert Atari to genirq
>>> á- [15/28] m68k/atari: Remove code and comments about different irq types
>>> á- [16/28] m68k/amiga: Refactor amiints.c
>>> á- [17/28] m68k/amiga: Convert Amiga to genirq
>>> á- [18/28] m68k/amiga: Optimize interrupts using chain handlers
>>> á- [19/28] m68k/mac: Convert Mac to genirq
>>> á- [20/28] m68k/mac: Optimize interrupts using chain handlers
>>> á- [21/28] m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
>>> á- [22/28] m68k/vme: Convert VME to genirq
>>> á- [23/28] m68k/apollo: Convert Apollo to genirq
>>> á- [24/28] m68k/sun3: Use the kstat_irqs_cpu() wrapper
>>> á- [25/28] m68k/sun3: Convert Sun3/3x to genirq
>>> á- [26/28] m68k/q40: Convert Q40/Q60 to genirq
>>> á- [27/28] m68k/irq: Remove obsolete m68k irq framework
>>> á- [28/28] m68k/irq: Remove obsolete support for user vector interrupt fixups
>>>
>>> Overview:
>>> á- [01] is a fix for the core genirq code,
>>
>> This went into v3.1-rc6.
>>
>>> á- [02-03] are fixes to avoid compile problems later in the conversion
>>> á áprocess,
>>
>> The keyboard path went into the tty -next tree.
>> The IDE one is still pending (I've just resent it).
>
> The IDE one got acked in the mean time.
>
>>> I will update my m68k-genirq branch as soon as master.kernel.org is available
>>> again.
>>
>> Updated, on top of m68k master (which is at v3.1-rc10 now).
>> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-genirq
>>
>> If noone objects, I'd like to add this to the m68k master and for-3.2 branches.
>
> I added it to m68k master.
>
> As there were several merge conflicts with current -next
> (arch/m68k/kernel/Makefile_mm
> due to the mmu/nommu merge, and drivers/net/macsonic.c in [12/28] due
> to the network
> driver reshuffling dance), I did not add it to for-3.2 and for-next,
> but to for-3.3.
>
> Depending on Stephen's return during or after the merge window, and
> the merge timing
> of the m68knommu and netdev trees, I may stil try to sneak it in 3.2, though.

I can ask Linus to pull the m68knommu tree early in the merge window,
if that will help.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
