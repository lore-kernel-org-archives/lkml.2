Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab3AIPDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:03:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39099 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab3AIPC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:02:58 -0500
Message-ID: <50ED868D.7040608@oracle.com>
Date: Wed, 09 Jan 2013 23:02:37 +0800
From: annie li <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Wilson <msw@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH v2] xen/grant-table: correctly initialize
 grant table version 1
References: <Message-ID: <1355997710.26722.12.camel@zakaz.uk.xensource.com>	<1357470882-17345-1-git-send-email-msw@amazon.com>	<50ECD89A.50100@oracle.com> <1357732929.7989.250.camel@zakaz.uk.xensource.com>
In-Reply-To: <1357732929.7989.250.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2013-1-9 20:02, Ian Campbell wrote:
> On Wed, 2013-01-09 at 02:40 +0000, ANNIE LI wrote:
>   
>>> @@ -1080,18 +1081,18 @@ static void gnttab_request_version(void)
>>>   		panic("we need grant tables version 2, but only version 1 is available");
>>>   	} else {
>>>   		grant_table_version = 1;
>>> +		grefs_per_grant_frame = PAGE_SIZE / sizeof(struct grant_entry_v1);
>>>   		gnttab_interface =&gnttab_v1_ops;
>>>   	}
>>> -	printk(KERN_INFO "Grant tables using version %d layout.\n",
>>> -		grant_table_version);
>>>   }
>>>   
>>>       
>> Is it better to keep printk here? In your last patch, you removed it 
>> because gnttab_request_version and gnttab_resume are all called in 
>> gnttab_init. and gnttab_resume also contains calling of 
>> gnttab_request_version. But in this patch, gnttab_setup is used, and 
>> does not have this issue now.
>>     
>
> Yes, I think we want to print this at both start of day and resume?
>   
Right.
> Either by adding a print to gnttab_resume()
Only adding a print into gnttab_resume() would miss this print at start 
of day. In gnttab_init, gnttab_request_version and gnttab_setup are 
called, not gnttab_resume.
>  or by keeping the existing
> one here in preference to moving it to gnttab_setup(). I'd prefer the
> latter to avoid the duplication, unless I'm mistaken and request_version
> is called in more than those two locations.
>   
Yes, I'd like the latter. Request_version is only called in those two 
locations.

Thanks
Annie
> Ian.
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
>   
