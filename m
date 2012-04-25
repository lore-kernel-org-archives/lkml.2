Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2DYC4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758788Ab2DYC4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:56:51 -0400
Message-ID: <4F9767EE.4010709@redhat.com>
Date: Tue, 24 Apr 2012 22:56:46 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111104 Red Hat/3.1.16-2.el6_1 Thunderbird/3.1.16
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
References: <20120410090306.GA7056@richard>	<20120422155202.GA13540@richard>	<4F95B17B.3030401@redhat.com>	<CAE9FiQX52eL6ZFQ_X3uL5DukK03sPhByZpPh0++o6L=WF8BGXg@mail.gmail.com>	<4F95C50C.4060203@redhat.com> <CAE9FiQVNYC1e_cHpLqsUcTCHWhzV_w0W=hVF8vkxtadjN45CWg@mail.gmail.com>
In-Reply-To: <CAE9FiQVNYC1e_cHpLqsUcTCHWhzV_w0W=hVF8vkxtadjN45CWg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 06:07 PM, Yinghai Lu wrote:
> On Mon, Apr 23, 2012 at 2:09 PM, Don Dutile<ddutile@redhat.com>  wrote:
>> On 04/23/2012 04:19 PM, Yinghai Lu wrote:
>>>
>>> On Mon, Apr 23, 2012 at 12:46 PM, Don Dutile<ddutile@redhat.com>    wrote:
>>>>
>>>> I have run into a similar problem recently when trying to use
>>>> pci=assign-busses
>>>> with an SRIOV device behind a non-ARI-capable PCIe switch.
>>>> In this scenario, the assign-busses code assigned the next bus number,
>>>> which conflicted with an existing one on the system, and hangs the
>>>> system -- two bridges responding to the same PCI bus num evidently
>>>> confuses the hw! ;-)
>>>
>>>
>>> can you post boot log and lspci -vvxxx?
>>>
>>> Yinghai
>>
>>
>> Attached requested logs of linux-3.4-rc2 booted on RHEL6.2 installation.
>>
>> I don't have a boot log of failing condition (pci=assign-devices)
>
> what is pci=assign-devices ? you have own local patches to handle that?
>
> or you mean pci=assign-busses?
>
yes, that's what I meant. sorry, my bad... :(

>> b/c it wedges at boot, and the serial line doesn't output anything
>> even though I've tried every magic trick known with grub&  kernel boot
>> params.
>> ... the PCI log btwn early boot and until the console is reconfigured is
>> 'lost'
>> on the serial line, and that's when the hang occurs.
>> It's been 'fun' to debug w/o that serial output...
>>
>> Let me know if you need something else. (lspci -t ?)
>
> can you check busn_alloc patchset fix the overlapping problem for you?
> It already split scan bus to two pass, also it  will double check not
> scanned peer bridges.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-pci-busn-alloc
>
> you can merge them to your 3.4-rc2...
>
> Thanks
>
> Yinghai
I'll try as soon as I get back to the office;
I'm out the next few days, and don't have external access to my test system.

