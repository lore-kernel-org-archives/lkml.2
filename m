Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0HWQUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:20:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab0HWQUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:20:06 -0400
Message-ID: <4C729F9E.1060907@redhat.com>
Date: Mon, 23 Aug 2010 19:19:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 03/12] Add async PF initialization to PV guest.
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-4-git-send-email-gleb@redhat.com> <4C729342.6070205@redhat.com> <20100823153549.GU10499@redhat.com> <alpine.DEB.2.00.1008231105230.8601@router.home>
In-Reply-To: <alpine.DEB.2.00.1008231105230.8601@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/23/2010 07:08 PM, Christoph Lameter wrote:
> On Mon, 23 Aug 2010, Gleb Natapov wrote:
>
>>> The guest will have to align this on a 64 byte boundary, should this
>>> be marked __aligned(64) here?
>>>
>> I do __aligned(64) when I declare variable of that type:
>>
>> static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
> 64 byte boundary: You mean cacheline aligned? We have a special define for
> that.
>
> DEFINE_PER_CPU_SHARED_ALIGNED
>

It's an ABI, so we can't use something that might change when Intel 
releases a cpu with 75.2 byte cache lines.

-- 
error compiling committee.c: too many arguments to function

