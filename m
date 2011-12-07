Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1LGDgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:36:55 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:35379 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1LGDgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:36:53 -0500
Message-ID: <4EDEDF44.4000307@oracle.com>
Date: Wed, 07 Dec 2011 11:36:36 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [PATCH 1/2] xen/granttable: Support sub-page grants
References: <4EDDF41E.8070200@oracle.com>  <1323168999-4434-1-git-send-email-annie.li@oracle.com> <1323171726.23681.65.camel@zakaz.uk.xensource.com> <4EDE4EC4.8070802@goop.org>
In-Reply-To: <4EDE4EC4.8070802@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4EDEDF51.0054,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> Returning -Esomething might be less drastic? ENOSYS perhaps?
> Yeah, BUG_ON shouldn't be used for API misuse unless there's absolutely
> no other way to handle it.
OK, will change it, thanks.
>>> +	gnttab_shared.v2[ref].sub_page.frame = frame;
>>> +	gnttab_shared.v2[ref].sub_page.page_off = page_off;
>>> +	gnttab_shared.v2[ref].sub_page.length = length;
>>> +	gnttab_shared.v2[ref].hdr.domid = domid;
>>> +	wmb();
>>> +	gnttab_shared.v2[ref].hdr.flags =
>>> +				GTF_permit_access | GTF_sub_page | flags;
>>> +}
>>> +EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_ref_subpage_v2);
>>> +
>>> +bool gnttab_subpage_trans_grants_available(void)
>>> +{
>>> +	return grant_table_version == 2;
>>> +}
>> It's not clear this adds anything over and above letting the user query
>> the grant table version. It's hard to tell since there are no users
>> presented here though. Perhaps separate subpage and transitive functions
>> would be cleaner?
> Well, in general, specifically testing for features rather than
> interface versions is better.
Ok, will split it into 2 functions and check the function pointer 
instead of grant table version, thanks.

Thanks
Annie

