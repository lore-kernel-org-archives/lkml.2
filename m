Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0GBHlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:41:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53019 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab0GBHlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:41:51 -0400
Message-ID: <4C2D975A.2050704@cn.fujitsu.com>
Date: Fri, 02 Jul 2010 15:38:02 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: IOAPIC: only access APIC registers one dword at
 a time
References: <4C2D6D4B.5060309@cn.fujitsu.com> <4C2D95EA.6080209@np.css.fujitsu.com>
In-Reply-To: <4C2D95EA.6080209@np.css.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jin Dongming wrote:

>>  
>>  	switch (len) {
>> -	case 8:
>> -		*(u64 *) val = result;
>> -		break;
>> -	case 1:
>> -	case 2:
>>  	case 4:
>> -		memcpy(val, (char *)&result, len);
> 
> Here the parameter len is not used for reading data from ioapic register, before switch case
> the value of ioapic register has been read by ioapic_read_indirect().
> 

Yeah, it's right, but it's rarely operation that guest using incorrect width to access
the registers, so i don't think it's worthy to move the width judgment before the real
registers read.

> 
>> +		*(u32 *) val = result;
>>  		break;
>> +
>>  	default:
>>  		printk(KERN_WARNING "ioapic: wrong length %d\n", len);
> 
> And I think here is not good to print warning message. Maybe it is better to do
> such kind of checking at the first of this function before ioapic_read_indirect().
> 

ditto

Thanks for your review, Jin!
