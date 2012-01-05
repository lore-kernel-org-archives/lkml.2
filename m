Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab2AEG3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:29:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41829 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab2AEG3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:29:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120104212808.GI2540@tuxdriver.com>
References: <NEXT-4f04c2111e5f83.17805410@nextmail.ru>
	<20120104212808.GI2540@tuxdriver.com>
Date: Thu, 5 Jan 2012 11:59:16 +0530
Message-ID: <CAD2nsn05O3e1ZnaK9ZMNk=qFFvLiB7oE-D+zfzofhVgosKibtg@mail.gmail.com>
Subject: Re: ath9k crash 3.2-rc7
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: MR <g7af0ec1e3ea1e7b1@nextmail.ru>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

we will take a look at this.

i can later come up with few debug patches to narrow down the panic.
looks like a problem in ath_update_survey_stats(survey pointer). full
stack trace will be helpful
thanks.

On Thu, Jan 5, 2012 at 2:58 AM, John W. Linville <linville@tuxdriver.com> wrote:
> You probably want to try linux-wireless@vger.kernel.org for maximum exposure...
>
> On Thu, Jan 05, 2012 at 01:18:09AM +0400, MR wrote:
>> Hello.
>>
>> I have noticed a complete crash (forced switch to console and Alt-SysRq-B
>> doesn't work) when I use ath9k driver for my WiFi card. The problem is that
>> the crash occurs after a few hours of use, so blind bissecting doesn't look
>> like a short-term plan.
>>
>> My card is (as lspci says):
>>
>> 03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless
>> Network Adapter (PCI-Express) (rev 01)
>>         Subsystem: Device 1a3b:1089
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 17
>>         Region 0: Memory at d7400000 (64-bit, non-prefetchable) [size=64K]
>>
>> I use an Asus N53JN notebook, if that matters.
>>
>> I have photos of two instances of the crash. The backtrace goes as follows (I
>> typed this in, so maybe there is a typo somewhere - I hope there is none,
>> though):
>>
>> wq_worker_sleeping+0x10/0xa0
>> __schedule+0x427/0x7b0
>> ? call_rcu_sched+0x10/0x20
>> schedule+0x3a/0x50
>> do_exit+0x57c/0x840
>> ? kmsg_dump+0x45/0xe0
>> oops_end+0xa5/0xf0
>> no_context+0xf2/0x270
>> __bad_area_no_semaphore+0xe/0x10
>> do_page_fault+0x2ba/0x450
>> ? up+0x2d/0x50
>> ? console_unlock+0x1df/0x250
>> ? select_task_rq_fair+0x5be/0x970
>> page_fault+0x25/0x30
>> ? ath_update_survey_stats+0xb7/0x1c0 [ath9k]
>> ath9k_config+0x115/0x780 [ath9k]
>> ? queue_work+0x1a/0x20
>> ? queue_delayed_work+0x25/0x30
>> ? ieee80211_queue_delayed_work+0x46/0x60 [mac80211]
>> ? ath9k_flush+0x155/0x1d0 [ath9k]
>> ieee80211_hw_config+0xe2/0x160 [mac80211]
>> ieee80211_scan_work+0x243/0x5c0 [mac80211]
>> ? ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
>> process_one_work+0x111/0x390
>> worker_thread+0x162/0x340
>> manage_workers.clone.26+0x240/0x240
>> kthread+0x96/0xa0
>> kernel_thread_helper+0x4/0x10
>> ? kthread_worker_fn+0x190/0x190
>> ? gs_change+0x13/0x13
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
shafi
