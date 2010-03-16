Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937455Ab0CPGyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:54:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55959 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S937150Ab0CPGx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:53:58 -0400
Message-ID: <4B9F2A54.9020505@cn.fujitsu.com>
Date: Tue, 16 Mar 2010 14:51:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Sheng Yang <sheng@linux.intel.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM MMU: check reserved bits only if CR4.PSE=1 or CR4.PAE=1
References: <4B9FCC42.2080709@cn.fujitsu.com> <4B9F17BC.50108@redhat.com> <4B9F1F47.2040700@cn.fujitsu.com> <4B9F2204.7050302@redhat.com>
In-Reply-To: <4B9F2204.7050302@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 03/16/2010 08:03 AM, Xiao Guangrong wrote:
>>
>>> I think the only change is that is !is_pse(vcpu) we ignore bit 7?
>>>      
>> If the vcpu is in PT32E_ROOT_LEVEL/PT64_ROOT_LEVEL mode, CR4.PAE
>> is aways enabled, so what we need do is ignore bit7 if !is_pse(vcpu)
>> under PT32_ROOT_LEVEL mode, right?
>>    
> 
> I think PAE will fault if bit7 is set and !is_pse(vcpu), but not sure.

Quote AMD's specification:
The size of large pages in PAE-paging mode is 2 Mbytes rather than 4 Mbytes. PAE uses
the pagedirectory page-size bit (PDE.PS) to allow selection between 4-Kbyte and 2-Mbyte
page sizes. PAE automatically uses the page-size bit, so the value of CR4.PSE is ignored
by PAE paging.

Quote Intel's specification:
When PAE is enabled, the 2-MByte page size is selected by setting the page size (PS)
flag in a page-directory entry (see Figure 3-14). (As shown in Table 3-3, the PSE flag
in control register CR4 has no affect on the page size when PAE is enabled.)

So i think PAE just ignore CR4.PSE

Thanks,
Xiao
