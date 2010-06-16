Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab0FPIGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab0FPIGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:06:04 -0400
Message-ID: <4C1885DF.80903@redhat.com>
Date: Wed, 16 Jun 2010 11:05:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
       Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 3/6] KVM: MMU: introduce gfn_to_page_atomic() and	gfn_to_pfn_atomic()
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E999.6050004@cn.fujitsu.com> <4C17625E.3020308@redhat.com> <20100616075918.GA17599@basil.fritz.box>
In-Reply-To: <20100616075918.GA17599@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 10:59 AM, Andi Kleen wrote:
> On Tue, Jun 15, 2010 at 02:22:06PM +0300, Avi Kivity wrote:
>    
>> Too much duplication.  How about putting the tail end of the function in a
>> common helper (with an inatomic flag)?
>>
>> btw, is_hwpoison_address() is racy.  While it looks up the address, some
>> other task can unmap the page tables under us.
>>      
> Where is is_hwpoison_address() coming from? I can't find it anywhere.
>
>    

kvm.git master mm/memory-failure.c (19564281fe).

> Anyways hwpoison will not remove the page as long as there
> is a reference to it, so as long as you get the reference
> race free against another task you're ok. Of course there might
> be always an error in between and the hardware may poison
> the data, but we don't try to handle all kernel errors.
>    

The page is fine, the page tables are not.  Another task can munmap() 
the thing while is_hwpoison_address() is running.

-- 
error compiling committee.c: too many arguments to function

