Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1LGK1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:27:55 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61013 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab1LGK1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:27:53 -0500
Message-ID: <4EDF3F96.8030600@oracle.com>
Date: Wed, 07 Dec 2011 18:27:34 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [PATCH 1/2] xen/granttable: Support sub-page grants
References: <4EDDF41E.8070200@oracle.com>	 <1323168999-4434-1-git-send-email-annie.li@oracle.com>	 <1323171726.23681.65.camel@zakaz.uk.xensource.com>	 <4EDEDF2E.3040204@oracle.com> <1323251784.23681.126.camel@zakaz.uk.xensource.com>
In-Reply-To: <1323251784.23681.126.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EDF3FA4.0132,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-12-7 17:56, Ian Campbell wrote:
> On Wed, 2011-12-07 at 03:36 +0000, ANNIE LI wrote:
>> Thanks for your reviewing, Ian.
>>>>    EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
>>>>
>>>> +int gnttab_grant_foreign_access_subpage_v2(domid_t domid, unsigned long frame,
>>>> +					   int flags, unsigned page_off,
>>>> +					   unsigned length)
>>> Please drop the v2 suffixes on the public functions.
>> OK, the initial interface is without v2 suffixes. It was added in order
>> to reminder user the interfaces are only available for grant table v2.
>> But I am fine to remove it, and following ops fn pointers are better.
>>> Any reason not to route these via the ops table for consistency with all
>>> the other ops? Then your availability check becomes a test for NULL fn
>>> pointer rather than a specific version.
>> Ok, it is good.
>> How about following implements?
> Looks to be along the right lines. Thanks.
>
>> gnttab_v1_ops = {
>>    ...
>> .access_subpage = NULL;
>> .access_ref_subpage = NULL;
>> .access_trans = NULL;
>> .access_ref_trans = NULL;
>> }
> I think you can omit these since NULL is the default but perhaps
> explicitly listing them is useful in a self documenting type way.
>
> [...]
OK, I can delete those.
>> Same operations for access_ref_subpage, access_trans and access_ref_trans.
>>
>> bool gnttab_subpage_available()
>> {
>>        return (gnttab_interface->access_subpage != NULL);
>> }
>>
>> bool gnttab_subpage_available()
> Typo:       ..trans..
Thanks for pointing out this.

Thanks
Annie
>> {
>>        return (gnttab_interface->access_trans != NULL);
>> }
> Ian.
>
>> Thanks
>> Annie
>
