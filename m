Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1JQGVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 02:21:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:53235 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab1JQGVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 02:21:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="63846731"
Message-ID: <4E9BC972.8010909@linux.intel.com>
Date: Mon, 17 Oct 2011 14:21:38 +0800
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
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/10/15 4:53, Seiji Aguchi 写道:
> Hi,
>
>   As Don mentioned in following thread, it would be nice for pstore/kmsg_dump to serialize
>   panic path and have one cpu running because they can log messages reliably.
>
>   https://lkml.org/lkml/2011/10/13/427
>
>   For realizing this idea, we have to move kmsg_dump below smp_send_stop() and bust some locks
>   of kmsg_dump/pstore in panic path.
>
>   This patch does followings.
>
>    - moving kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop.
>    - busting logbuf_lock of kmsg_dump() in panic path for avoiding deadlock.
>    - busting psinfo->buf_lock of pstore_dump() in panic path for avoiding deadlock.
>
> Any comments are welcome.
>

Hi, Seiji

I have a stupid question: since you have serialized the process procedure via 
smp_send_stop, why still using spin_lock_xxx? Maybe preempt_disable/enable is 
enough?
