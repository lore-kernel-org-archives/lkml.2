Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2BTK1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:27:49 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55775 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2BTK1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:27:48 -0500
Message-ID: <4F42201D.4080807@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 18:27:41 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: KVM: perf: a smart tool to analyse kvm events
References: <20120216155248.6865.47935.sendpatchset@localhost.localdomain> <4F3DBCD8.2020505@linux.vnet.ibm.com> <20120220102029.GC8666@linux.vnet.ibm.com>
In-Reply-To: <20120220102029.GC8666@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12022000-5490-0000-0000-000000C59A5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 06:20 PM, Pradeep Kumar Surisetty wrote:

> * Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> [2012-02-17 10:35:04]:
> 
>> On 02/16/2012 11:52 PM, Pradeep Kumar wrote:
>>
>>> Xiao,
>>>
>>>  i tried your perf events patch set on RHEL 6.1 host and failed to trace kvm-events with below error message.
>>>
>>>   [root@kvm perf]# ./perf kvm-events report
>>>   Warning: unknown op '{'
>>>   Warning: Error: expected type 5 but read 1
>>>   Warning: failed to read event print fmt for hrtimer_start
>>>   Warning: unknown op '{'
>>>   Warning: Error: expected type 5 but read 1
>>>   Warning: failed to read event print fmt for hrtimer_expire_entry
>>>   Analyze events for all VCPUs:
>>>   VM-EXIT    Samples  Samples%     Time%         Avg time               
>>>   Total Samples:0, Total events handled time:0.00us.
>>>   [root@kvm perf]#          
>>> 	     
>>
>>
>> Thanks for your try, Pradeep!
>>
>> It seems that kvm events do not be recorded.
>>
>> Do your guest was running when kvm-events was executed?
> 
> Hello Xiao
> 
> my guest was not running when i executed. 
> 


kvm-events only analyse kvm events and this events are generated only when
kvm guest is running. :)

>> What is the output of "./perf script | grep kvm_*"?
> 
> [root@phx3 perf]# ./perf script | grep kvm_*
> Warning: unknown op '{'
> Warning: Error: expected type 5 but read 1
> Warning: failed to read event print fmt for hrtimer_start
> Warning: unknown op '{'
> Warning: Error: expected type 5 but read 1
> Warning: failed to read event print fmt for
> hrtimer_expire_entry
> # cmdline : /home/patch/linux/tools/perf/perf record -a -R
> # -f -m 1024 -c 1 -e kvm:kvm_entry -e kvm:kvm_exit -e
> # kvm:kvm_mmio -e kvm:kvm_pio -e timer:* 
> # event : name = kvm:kvm_entry, type = 2, config = 0x2ef,
> # config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0,
> # id = { 6241, 6242, 6243, 6244, 6245, 6246, 6247, 6248 }
> # event : name = kvm:kvm_exit, type = 2, config = 0x2ea,
> # config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0,
> # id = { 6249, 6250, 6251, 6252, 6253, 6254, 6255, 6256 }
> # event : name = kvm:kvm_mmio, type = 2, config = 0x2dd,
> # config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0,
> # id = { 6257, 6258, 6259, 6260, 6261, 6262, 6263, 6264 }
> # event : name = kvm:kvm_pio, type = 2, config = 0x2ed,
> # config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0,
> # id = { 6265, 6266, 6267, 6268, 6269, 6270, 6271, 6272 }
> no symbols found in /sbin/killall5, maybe install a debug
> package?
> 


That means no kvm event is recorded, please try it again when
your kvm guest is running.

Thanks, Pradeep!

