Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab1LGKuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:50:51 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:43438 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1LGKuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:50:50 -0500
Message-ID: <4EDF44F8.8060206@oracle.com>
Date: Wed, 07 Dec 2011 18:50:32 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Paul Durrant <Paul.Durrant@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Subject: Re: [PATCH 1/2] xen/granttable: Support sub-page grants
References: <4EDDF41E.8070200@oracle.com>	 <1323168999-4434-1-git-send-email-annie.li@oracle.com>	 <1323171726.23681.65.camel@zakaz.uk.xensource.com>	 <4EDEDF2E.3040204@oracle.com>	 <291EDFCB1E9E224A99088639C4762022B5988E542E@LONPMAILBOX01.citrite.net>	 <1323251849.23681.128.camel@zakaz.uk.xensource.com>	 <4EDF3F9B.4030407@oracle.com> <1323254036.23681.142.camel@zakaz.uk.xensource.com>
In-Reply-To: <1323254036.23681.142.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EDF4505.00E6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The existing convention seems to be for _ref to be a suffix, although
> it's only actually used on the end_*_ref ones.
> +       int (*end_foreign_access_ref)(grant_ref_t, int);
> +       unsigned long (*end_foreign_transfer_ref)(grant_ref_t);
>
> Also it occurs to me that access_* sounds like something which uses a
> ref rather than something which sets one up. The existing hook to setup
> a normal grant is called "update_entry". Perhaps
> update_{subpage,transitive}_entry?
Yes, you are right.
Just like the existing code:
gnttab_grant_foreign_access   VS   gnttab_grant_foreign_access_subpage
update_entry in gnttab_grant_foreign_access_ref  VS  
update_{subpage,transitive}_entry in 
gnttab_grant_foreign_access_{subpage,trans}_ref

Thanks
Annie
