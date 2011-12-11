Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1LKGGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 01:06:15 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:19500 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab1LKGGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 01:06:14 -0500
Message-ID: <4EE44831.8060002@oracle.com>
Date: Sun, 11 Dec 2011 14:05:37 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Subject: Re: [PATCH V3 1/2] xen/granttable: Support sub-page grants
References: <1323430321-5465-1-git-send-email-annie.li@oracle.com>	 <1323430372-5503-1-git-send-email-annie.li@oracle.com> <1323452339.20077.92.camel@zakaz.uk.xensource.com>
In-Reply-To: <1323452339.20077.92.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EE44851.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-12-10 1:38, Ian Campbell wrote:
> On Fri, 2011-12-09 at 11:32 +0000, annie.li@oracle.com wrote:
>> -- They can't be used to map the page (so can only be used in a GNTTABOP_copy
>>         hypercall).
>>      -- It's possible to grant access with a finer granularity than whole pages.
>>      -- Xen guarantees that they can be revoked quickly (a normal map grant can
>>         only be revoked with the cooperation of the domain which has been granted
>>         access).
>>
>> Signed-off-by: Annie Li<annie.li@oracle.com>
>> ---
>>   drivers/xen/grant-table.c |   71 +++++++++++++++++++++++++++++++++++++++++++++
>>   include/xen/grant_table.h |   13 ++++++++
>>   2 files changed, 84 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
>> index bd325fd..0ac16fa 100644
>> --- a/drivers/xen/grant-table.c
>> +++ b/drivers/xen/grant-table.c
>> @@ -120,6 +120,16 @@ struct gnttab_ops {
>>   	 * by bit operations.
>>   	 */
>>   	int (*query_foreign_access)(grant_ref_t);
>> +	/*
>> +	 * Grant a domain to access a range of bytes within the page referred by
>> +	 * an available grant entry. First parameter is grant entry reference
>> +	 * number, second one is id of grantee domain, third one is frame
>> +	 * address of subpage grant, forth one is grant type and flag
>> +	 * information, fifth one is offset of the range of bytes, and last one
>> +	 * is length of bytes to be accessed.
>> +	 */
>> +	void (*update_subpage_entry)(grant_ref_t, domid_t, unsigned long, int,
>> +				     unsigned, unsigned);
> Please can you name the arguments here and then refer to them by name in
> the comments instead of all this "First parameter", "second one" stuff.
>
> Similarly for the existing comments sorry I didn't notice this in
> previous review.
Ok, I will do this in another separate patch.

Thanks,
Annie.
> Ian.
>
>
