Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab1JRH22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:28:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:37998 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab1JRH21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:28:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,363,1315206000"; 
   d="scan'208";a="79153078"
Message-ID: <4E9D2A85.1030307@linux.intel.com>
Date: Tue, 18 Oct 2011 15:28:05 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping other
 cpus in panic path
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com> <4E9BC972.8010909@linux.intel.com> <5C4C569E8A4B9B42A84A977CF070A35B2C5747E157@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C5747E157@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/10/17 22:10, Seiji Aguchi 写道:
> Hi,
>
> Thank you for giving me a comment.
>
>> I have a stupid question: since you have serialized the process procedure via
>> smp_send_stop, why still using spin_lock_xxx? Maybe preempt_disable/enable is
>> enough?
>
>
> I added spin_lock_init() in panic path for sharing code with other triggers
> such as oops/reboot/emergency_restart because they still need spin_locks.
>
> Do you suggest following code?
>
> <snip>
> If(!panic)
> 	spin_lock_irqsave();
>
>       .
>       .
> If(!panic)
> 	spin_unlock_restore();
> <snip>
>
> I don't stick to current patch.
> So I will resend a patch above if you request.

Yes, it looks more readable.

+	if (reason == KMSG_DUMP_PANIC)
+		raw_spin_lock_init(&logbuf_lock);

above codes look a little bit confused

