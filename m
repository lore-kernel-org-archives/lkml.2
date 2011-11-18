Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1KRQLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:11:12 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:42418 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab1KRQLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:11:09 -0500
Message-ID: <4EC6837F.1050201@oracle.com>
Date: Sat, 19 Nov 2011 00:10:39 +0800
From: annie li <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 2/3] xen/granttable: Grant tables V2 implementation
References: <4EC3B62F.6080702@oracle.com>	 <1321451372-13596-1-git-send-email-annie.li@oracle.com>	 <4EC62FE5.2080608@oracle.com>	 <1321614166.3664.311.camel@zakaz.uk.xensource.com>	 <20111118135221.GC12433@phenom.dumpdata.com> <1321624845.3664.354.camel@zakaz.uk.xensource.com>
In-Reply-To: <1321624845.3664.354.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4EC68399.0087,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-11-18 22:00, Ian Campbell wrote:
> On Fri, 2011-11-18 at 13:52 +0000, Konrad Rzeszutek Wilk wrote:
>   
>>>> +                       xen_raw_printk(str);
>>>> +                       panic(str);
>>>>         
>>> I expect you've just copied this style from elsewhere but I really
>>> dislike this duplication of prints. If panic is not useful here we
>>> really ought to address that at the root instead of going around
>>> patching things to print every panic message twice. I thought
>>> earlyprintk was supposed to solve this problem. Perhaps a generic
>>> early_panic_print could be added to the panic code?
>>>       
>> We are using this combo in swiotlb-xen and as well in the xen pci.
>> We could declere a 'xen_raw_panic' that would do the job?
>>
>> The problem is that panic() uses the "late" printk mechanism (so
>> it goes through the buffer that ends up not beign flushed) and the
>> panic never sees the light.
>>     
>
> So lets fix that instead of working around it...
>
>   
>>  The 'xen_raw_printk' is synchronous..
>>
>> But I wonder if the panic surfaces if 'earlyprintk=xen' is used?
>> At which point it might be that the those extra xen_raw_printk
>> become pointless?
>>     
>
> I think panic's do come out with earlyprintk (unless they are truly
> super early).
>   
So we have two candidates:
xen_raw_printk + panic
panic + earlyprintk=xen

If panic does work with earlyprintk, then the latter one is better. 
Otherwise, there will be duplicated string printed out with 
'earlyprintk=xen'.

Thanks
Annie
> Ian.
>
>
>
>   
