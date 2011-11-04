Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1KDJQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:16:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37616 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab1KDJQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:16:11 -0400
Message-ID: <4EB3AD54.9050605@gmail.com>
Date: Fri, 04 Nov 2011 17:16:04 +0800
From: Xiao Guangrong <xiao.grong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
References: <4E7AF758.7060900@cn.fujitsu.com> <20111006175333.GA3959@amt.cnet> <4E8FCC37.8090409@cn.fujitsu.com> <4E91926D.8060206@redhat.com> <4E91A3AA.1000309@redhat.com> <4E940018.1010908@cn.fujitsu.com>
In-Reply-To: <4E940018.1010908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 04:36 PM, Xiao Guangrong wrote:
> On 10/09/2011 09:37 PM, Avi Kivity wrote:
>> On 10/09/2011 02:24 PM, Avi Kivity wrote:
>>> On 10/08/2011 06:06 AM, Xiao Guangrong wrote:
>>>> On 10/07/2011 01:53 AM, Marcelo Tosatti wrote:
>>>>>   On Thu, Sep 22, 2011 at 04:52:40PM +0800, Xiao Guangrong wrote:
>>>>>>   This patchset is against https://github.com/avikivity/kvm.git next branch.
>>>>>>
>>>>>>   In this version, some changes come from Avi's comments:
>>>>>>   - fix instruction retried for nested guest
>>>>>>   - skip write-flooding for the sp whose level is 1
>>>>>>   - rename some functions
>>>>>
>>>>>   Please rebase.
>>>>>
>>>>>
>>>>
>>>> Marcelo,
>>>>
>>>> These patches can be applied without any conflict and it also works well,
>>>> the current code was pulled from https://github.com/avikivity/kvm.git next branch.
>>>>
>>>> What problem did you meet when you applied these? :(
>>>
>>> I guess it was a user error - it applies cleanly here too (and pushed to next, thanks).
>>>
>>
>> However, it seems to reduce performance.
>>
>
> Ouch, will look into it soon.

Hi Avi,

I have done kernbench tests several times on my desktop, but it shows 
very well:

before patchset:
real 212.27
real 213.47
real 204.99
real 200.58
real 199.99
real 199.94
real 201.51
real 199.83
real 198.19
real 205.13

after patchset:
real 199.90
real 201.89
real 194.54
real 188.71
real 185.75
real 187.70
real 188.99
real 188.53
real 186.29
real 188.25

I will test it on our server using kvm-autotest, could you share me your 
config file please?
