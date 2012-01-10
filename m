Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2AJDGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 22:06:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:43860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab2AJDGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 22:06:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="94629474"
Message-ID: <4F0BAB33.2090201@linux.intel.com>
Date: Tue, 10 Jan 2012 11:06:27 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: Don Zickus <dzickus@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com> <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF81@USINDEVS01.corp.hds.com> <3908561D78D1C84285E8C5FCA982C28FBB21@ORSMSX104.amr.corp.intel.com> <5C4C569E8A4B9B42A84A977CF070A35B2C5827B01D@USINDEVS01.corp.hds.com> <20120105210123.GI5650@redhat.com> <5C4C569E8A4B9B42A84A977CF070A35B2C5827BBD8@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C5827BBD8@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/1/10 1:59, Seiji Aguchi 写道:
>>
>> I don't know how to prove something is hardened other than not seeing any
>> hangs or false reboots on in that piece of code.
>>
>
> I don't know how we can prove reliability of smp_send_stop() of all archs as well.
>
> Another possible solution is replacing smp_send_stop() with
> machine_crash_shutdown().
> This is a function call stopping other cpus reliably in panic situation
> so that kdump can work .
> But, I don't know whether it works in all archs.

machine_crash_shutdown is defined in only some Archs so it is obvious that it
can't be used in all platforms, BTW, this function is bracketed by CONFIG_KEXEC,
which means it can't be used without this macro. So it is not suitable for
this scenario.

> We need further discussion with Eric for checking this idea is feasible...
>
>
> I would like to go forward step by step rather than doing tough work at once.
> I think just moving kmsg_dump() below smp_send_stop() is a good start for improving pstore.

I agree with you. How about adding macros or something like WARN_ON(XX_ARCH) or
Kconfig to limit its scope?

