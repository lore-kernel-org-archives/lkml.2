Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2BMSP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:15:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab2BMSPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:15:25 -0500
Message-ID: <4F39532B.3060203@redhat.com>
Date: Mon, 13 Feb 2012 19:15:07 +0100
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        jacob.jun.pan@linux.intel.com, alan@linux.intel.com,
        feng.tang@intel.com, konrad.wilk@oracle.com, avi@redhat.com,
        glommer@redhat.com, johnstul@us.ibm.com, riel@redhat.com,
        tj@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, amit.shah@redhat.com
Subject: Re: [PATCH RFC] pvclock: Make pv_clock more robust and fixup it if
 overflow happens
References: <20120213130727.GA8052@amt.cnet> <1329147959-22472-1-git-send-email-imammedo@redhat.com> <20120213174837.GA11513@amt.cnet>
In-Reply-To: <20120213174837.GA11513@amt.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 06:48 PM, Marcelo Tosatti wrote:
> On Mon, Feb 13, 2012 at 04:45:59PM +0100, Igor Mammedov wrote:
>> Instead of hunting misterious stalls/hungs all over the kernel when
>> overflow occurs at pvclock.c:pvclock_get_nsec_offset
>>
>>      u64 delta = native_read_tsc() - shadow->tsc_timestamp;
>>
>> and introducing hooks when places of unexpected access found, pv_clock
>> should be initialized for the calling cpu if overflow condition is detected.
>>
>> Signed-off-by: Igor Mammedov<imammedo@redhat.com>
>
> Igor,
>
> I disagree. This is fixing the symptom not the root cause. Additionally,
> Xen also uses pvclock_clocksource_read.
>
> How about adding a BUG_ON to detect the overflow, this way hunting for
> the problem is not necessary.
>
Ok, I'll repost bug_on version.
