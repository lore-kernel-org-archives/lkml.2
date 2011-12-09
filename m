Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab1LIHpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 02:45:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:36359 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1LIHpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 02:45:31 -0500
Message-ID: <4EE1BC7E.3060904@oracle.com>
Date: Fri, 09 Dec 2011 15:45:02 +0800
From: annie li <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: annie li <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Subject: Re: [PATCH V2 1/2] xen/granttable: Support sub-page grants
References: <1323336940-5382-1-git-send-email-annie.li@oracle.com> <1323337048-5426-1-git-send-email-annie.li@oracle.com> <291EDFCB1E9E224A99088639C4762022B5988E5528@LONPMAILBOX01.citrite.net> <4EE08B0D.80504@oracle.com> <291EDFCB1E9E224A99088639C4762022B5988E552D@LONPMAILBOX01.citrite.net> <4EE19A4D.9030500@oracle.com>
In-Reply-To: <4EE19A4D.9030500@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EE1BC97.0018,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-12-9 13:19, annie li wrote:
> Hi Paul,
>
>>>> #define get_free_entry()    get_free_entries(1)
> Is this necessary? Maybe you defined this to keep consistence with 
> put_free_entry(ref)?
> But other functions such as gnttab_grant_foreign_transfer and 
> gnttab_grant_foreign_access all call get_free_entries(1). Maybe it is 
> better to keep initial get_free_entries(1) code?
Another approach is doing those work in a separate patch -- changing 
get_free_entries to get_free_entry in following 4 functions:
gnttab_grant_foreign_access
gnttab_grant_foreign_access_subpage
gnttab_grant_foreign_access_trans
gnttab_grant_foreign_transfer

Thanks
Annie
