Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2LKQDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:03:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:34808 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab2LKQDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:03:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,260,1355126400"; 
   d="scan'208";a="260554281"
Message-ID: <50C75935.1040004@linux.intel.com>
Date: Tue, 11 Dec 2012 08:03:01 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Alex Shi <alex.shi@intel.com>,
        Alex Shi <lkml.alex@gmail.com>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into
 LB and power awareness scheduling
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com> <50C722AC.3080806@intel.com> <20121211154819.GC8873@liondog.tnic>
In-Reply-To: <20121211154819.GC8873@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 7:48 AM, Borislav Petkov wrote:
> On Tue, Dec 11, 2012 at 08:10:20PM +0800, Alex Shi wrote:
>> Another testing of parallel compress with pigz on Linus' git tree.
>> results show we get much better performance/power with powersaving and
>> balance policy:
>>
>> testing command:
>> #pigz -k -c  -p$x -r linux* &> /dev/null
>>
>> On a NHM EP box
>>           powersaving               balance   	         performance
>> x = 4    166.516 /88 68           170.515 /82 71         165.283 /103 58
>> x = 8    173.654 /61 94           177.693 /60 93         172.31 /76 76
>
> This looks funny: so "performance" is eating less watts than
> "powersaving" and "balance" on NHM. Could it be that the average watts
> measurements on NHM are not correct/precise..? On SNB they look as
> expected, according to your scheme.

well... it's not always beneficial to group or to spread out
it depends on cache behavior mostly which is best

