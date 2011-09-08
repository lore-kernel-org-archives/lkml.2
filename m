Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab1IHJ1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:27:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:62810 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1IHJ1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:27:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,349,1312182000"; 
   d="scan'208";a="46709886"
Message-ID: <4E688A00.6090704@linux.intel.com>
Date: Thu, 08 Sep 2011 17:25:20 +0800
From: Minskey Guo <chaohong_guo@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Chen Gong <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 5/5] mce: recover from "action required" errors reported
 in data path in usermode
References: <4e5eb50721061dbb1b@agluck-desktop.sc.intel.com> <4E6709B2.7020401@linux.intel.com> <4E683108.8020000@linux.intel.com> <987664A83D2D224EAE907B061CE93D5301EA9704CD@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EA9704CD@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2011 01:16 PM, Luck, Tony wrote:
>>     __memory_failure() handling calls  some routines, such
>> as  is_free_buddy_page(),  which needs to acquire the spin
>> lock,  zone->lock. How can we guarantee that other CPUs
>> haven't acquired the lock when receiving #mc broadcast
>> and entering #mc handlers ?
> By the time I call __memory_failure() - the other cpus have
> been released from mce handler - so they are back executing
> normal code.
Oh, yes,  I just realized that mce_end() released other
cpus. So, printk/lock is not an issue here.


> But Chen Gong's earlier comments made me look again at entry_64.S
> code - ane I realized that I missed seeing code in the return
> path from do_machine_check() that switched from MCE stack to
> regular kernel stack before processing TIF_MCE_NOTIFY.
>
> I may go back and re-visit a path that I looked at to change
> do_machine_check from "void" return to "unsigned long" and have
> it return the address for the "AR" case and "0" otherwise.
> Then we could switch out of machine check stack to non-mce
> context to call __memory_failure().  When I looked at this
> before the entry_64.S path looked plausible. The 32-bit
> path looked to be painful (too many macros in entry_32.S)
>
Why do you plan to switch out of machine check stack while
call __memory_failure() in do_machine_check(),  what's the
benefits ?

thanks
-minskey


> -Tony
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{����zX����ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢf��^jǫy�m��@A�a���0��h��i

