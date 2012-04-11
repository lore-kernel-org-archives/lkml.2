Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067Ab2DKUJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:09:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50641 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2DKUJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:09:37 -0400
Subject: Re: [PATCH] clocksource: Load the ACPI PM clocksource asynchronously
Date: Wed, 11 Apr 2012 20:04:45 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Arjan van de Ven <arjanvandeven@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Message-ID: <041683e0088341c2b6d78e97f05948eb-mfwitten@gmail.com>
In-Reply-To: <CADyApD2UZebJd_nSJHAWkjz=PT4_DZfnSr38geqUb1kvJzKi-g@mail.gmail.com>
References: <20120130205120.652aa64f@infradead.org>
            <717f591b21b34ebea5793c6206b8a2b8-mfwitten@gmail.com>
            <CADyApD2UZebJd_nSJHAWkjz=PT4_DZfnSr38geqUb1kvJzKi-g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Apr 2012 19:20:22 -0700, Arjan van de Ven wrote:

>> to which I bisected as the culprit for very strange load balance
>> behavior on my machine.
>>
>> With this patch in place, my CPU is constantly being pegged at 100%
>> (and my CPU monitor sometimes registers NaN%), regardless of the
>> active governor and under conditions when my computer would normally
>> be idling quite placidly.
>>
>> Reverting this commit does indeed remove the problem from previously
>> problematic builds.
>>
>>
> any chance of a dmesg? (or even better, a diff of the dmesg from
> abefore and fter)

Doh! I should have thought of that.

The dmesg output for a kernel built from your patch's commit yields
this interesting line:

  PM-Timer running at invalid rate: 113% of normal - aborting.

That certainly sounds unsavory!

Here is some other, probably uninteresting context:

  --- good-dmesg.txt
  +++ bad-dmesg.txt
  [...]
   Initializing cgroup subsys cpu
  -Linux version 3.3.0-rc1-good-12d6d41276def096cb3f7dc36f438db9ed6a0a8d+ [...]
  +Linux version 3.3.0-rc1-bad-b519508298e0292e1771eecf14aaf67755adc39d+ [...]
  [...]
   Fast TSC calibration using PIT
  -Detected 798.093 MHz processor.
  +Detected 798.071 MHz processor.
  -Calibrating delay loop (skipped), value calculated using timer frequency.. 1596.18 BogoMIPS (lpj=798093)
  +Calibrating delay loop (skipped), value calculated using timer frequency.. 1596.14 BogoMIPS (lpj=798071)
   pid_max: default: 32768 minimum: 301
   Mount-cache hash table entries: 512
   Initializing cgroup subsys cpuacct
  [...]
   system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
   pnp: PnP ACPI: found 13 devices
   ACPI: ACPI bus type pnp unregistered
  -Switching to clocksource acpi_pm
  [...]
  +PM-Timer running at invalid rate: 113% of normal - aborting.

Sincerely,
Michael Witten

P.S.

I'm terribly sorry for the delayed reply; Gmail somehow managed to
throw away this thread entirely (actually, I probably threw it away,
but I'm content to blame my tools; after all, they can't deny it!).
