Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3AJLB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:01:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29782 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3AJLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:01:55 -0500
Message-ID: <50EE9FBC.6050209@oracle.com>
Date: Thu, 10 Jan 2013 19:02:20 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Matt Wilson <msw@amazon.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH v2] xen/grant-table: correctly initialize
 grant table version 1
References: <1355997710.26722.12.camel@zakaz.uk.xensource.com> <1357470882-17345-1-git-send-email-msw@amazon.com> <50ECD89A.50100@oracle.com> <1357732929.7989.250.camel@zakaz.uk.xensource.com> <20130110091652.GB6316@u109add4315675089e695.ant.amazon.com>
In-Reply-To: <20130110091652.GB6316@u109add4315675089e695.ant.amazon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2013-1-10 17:16, Matt Wilson wrote:
> On Wed, Jan 09, 2013 at 12:02:09PM +0000, Ian Campbell wrote:
>> On Wed, 2013-01-09 at 02:40 +0000, ANNIE LI wrote:
>>>> @@ -1080,18 +1081,18 @@ static void gnttab_request_version(void)
>>>>    		panic("we need grant tables version 2, but only version 1 is available");
>>>>    	} else {
>>>>    		grant_table_version = 1;
>>>> +		grefs_per_grant_frame = PAGE_SIZE / sizeof(struct grant_entry_v1);
>>>>    		gnttab_interface =&gnttab_v1_ops;
>>>>    	}
>>>> -	printk(KERN_INFO "Grant tables using version %d layout.\n",
>>>> -		grant_table_version);
>>>>    }
>>>>
>>> Is it better to keep printk here? In your last patch, you removed it
>>> because gnttab_request_version and gnttab_resume are all called in
>>> gnttab_init. and gnttab_resume also contains calling of
>>> gnttab_request_version. But in this patch, gnttab_setup is used, and
>>> does not have this issue now.
>> Yes, I think we want to print this at both start of day and resume?
>>
>> Either by adding a print to gnttab_resume() or by keeping the existing
>> one here in preference to moving it to gnttab_setup(). I'd prefer the
>> latter to avoid the duplication, unless I'm mistaken and request_version
>> is called in more than those two locations.
> In this version the printk() is in gnttab_setup(), which is called
> both at start of day (gnttab_init()) and resume (gnttab_resume()). I
> can move it back to gnttab_request_version() if you'd like, but this
> patch should be behaving as expected already.

I was thinking to change less from original source code, this patch 
moves printk without specific purpose and shows same behavior as 
original code. It is OK if you'd like to keep it.

Thanks
Annie
>
> Matt
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
