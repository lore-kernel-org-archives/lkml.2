Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0JSCx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:53:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51825 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756645Ab0JSCx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:53:27 -0400
Message-ID: <4CBD0830.4030301@cn.fujitsu.com>
Date: Tue, 19 Oct 2010 10:53:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy()
 for unaligned copy
References: <4CAEC81C.1070108@cn.fujitsu.com> <C10D3FB0CD45994C8A51FEC1227CE22F15C916E769@shsmsx502.ccr.corp.intel.com> <4CAEDE0D.2040009@cn.fujitsu.com> <4CB62543.7000605@zytor.com> <C10D3FB0CD45994C8A51FEC1227CE22F15CC203E71@shsmsx502.ccr.corp.intel.com> <4CBBE7FB.2060303@cn.fujitsu.com> <C10D3FB0CD45994C8A51FEC1227CE22F15D77721FD@shsmsx502.ccr.corp.intel.com> <4CBBEA7F.7010604@cn.fujitsu.com> <C10D3FB0CD45994C8A51FEC1227CE22F15D777221E@shsmsx502.ccr.corp.intel.com> <4CBBFA7F.1010109@cn.fujitsu.com> <C10D3FB0CD45994C8A51FEC1227CE22F15D77722D0@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <C10D3FB0CD45994C8A51FEC1227CE22F15D77722D0@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 16:01:13 +0800, Ma, Ling wrote:
>>> rep_good will cause memcpy jump to memcpy_c, so not run this patch,
>>> we may continue to do further optimization on it later.
>
>> Yes, but in fact, the performance of memcpy_c is not better on some micro-architecture(such as:
>> Wolfdale-3M, ), especially in the unaligned cases, so we need do optimization for it, and I think
>> the first step of optimization is optimizing the original code of memcpy().
>
> As mentioned above , we will optimize further memcpy_c soon.
> Two reasons :
>    1. movs instruction need long lantency to startup
>    2. movs instruction is not good for unaligned case.
>
>>> BTW the improvement is only from core2 shift register optimization,
>>> but for most previous cpus shift register is very sensitive because of decode stage.
>>> I have test Atom, Opteron, and Nocona, new patch is still better.
>
>> I think we can add a flag to make this improvement only valid for Core2 or other CPU like it,
>> just like X86_FEATURE_REP_GOOD.
>
> We should optimize core2 in memcpy_c function in future, I think.

But there is a problem, the length of new instruction must be less or equal the length of
original instruction if we use alternatives, but IT seems the length of core2's optimization
instruction may be greater than the original instruction. So I think we can't optimize core2
in memcpy_c function, just in memcpy function.

Regards
Miao
