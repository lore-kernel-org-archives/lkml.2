Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2JPEvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:51:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:47895 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab2JPEvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:51:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="156590103"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "x86@kernel.org" <x86@kernel.org>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "Brown, Len" <len.brown@intel.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: RE: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Thread-Topic: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Thread-Index: AQHNq1e0cdLRWLkn60qkdlE2ARg+FJe7WVDQ
Date: Tue, 16 Oct 2012 04:51:36 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122030B0DD68@ORSMSX105.amr.corp.intel.com>
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
In-Reply-To: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9G4q0Xt029593

> -----Original Message-----
> From: HATAYAMA Daisuke [mailto:d.hatayama@jp.fujitsu.com]
> Sent: Monday, October 15, 2012 9:35 PM
> To: linux-kernel@vger.kernel.org; kexec@lists.infradead.org;
> x86@kernel.org
> Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; Brown, Len; Yu,
> Fenghua; vgoyal@redhat.com; ebiederm@xmission.com;
> grant.likely@secretlab.ca; rob.herring@calxeda.com;
> d.hatayama@jp.fujitsu.com
> Subject: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
> 
> Multiple CPUs are useful for CPU-bound processing like compression and
> I do want to use compression to generate crash dump quickly. But now
> we cannot wakeup the 2nd and later cpus in the kdump 2nd kernel if
> crash happens on AP. If crash happens on AP, kexec enters the 2nd
> kernel with the AP, and there BSP in the 1st kernel is expected to be
> haling in the 1st kernel or possibly in any fatal system error state.
> 
> To wake up AP, we use the method called INIT-INIT-SIPI. INIT causes
> BSP to jump into BIOS init code. A typical visible behaviour is hang
> or immediate reset, depending on the BIOS init code.
> 
> AP can be initiated by INIT even in a fatal state: MP spec explains
> that processor-specific INIT can be used to recover AP from a fatal
> system error. On the other hand, there's no method for BSP to recover;
> it might be possible to do so by NMI plus any hand-coded reset code
> that is carefully designed, but at least I have no idea in this
> direction now.

In my BSP hotplug patchset, BPS is waken up by NMI. The patchset is
not in tip tree yet.

BSP hotplug patchset can be found at https://lkml.org/lkml/2012/10/12/336

> 
> Therefore, the idea I do in this patch set is simply to disable BSP if
> vboot cpu is AP.
> 

The BSP hotplug patchset will be useful for you goal. With the BSP hotplug
patcheset, you can wake up BSP and don't need to disable it.

> My motivation is to use multiple CPUs in order to quickly generate
> crash dump on the machine with huge amount of memory. I assume such
> machine tends to also have a lot of CPUs. So disabling one CPU would
> be no problem.

Luckily you don't need to disable any CPU to archive your goal with
the BSP hotplug pachest:)

On a dual core/single thread machine, this means you get 100% performance
boost with BSP's help.

Plus crash dump kernel code is better structured by not treating BSP
specially.

Thanks.

-Fenghua


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
