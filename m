Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1LGI7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:59:49 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:17035 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab1LGI7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:59:48 -0500
X-IronPort-AV: E=Sophos;i="4.71,313,1320624000"; 
   d="scan'208";a="9335241"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: ANNIE LI <annie.li@oracle.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Wed, 7 Dec 2011 08:59:54 +0000
Subject: RE: [PATCH 1/2] xen/granttable: Support sub-page grants
Thread-Topic: [PATCH 1/2] xen/granttable: Support sub-page grants
Thread-Index: Acy0kWlTUi6fNwM7RkGEcuaSxoQaNwALOQeA
Message-ID: <291EDFCB1E9E224A99088639C4762022B5988E542E@LONPMAILBOX01.citrite.net>
References: <4EDDF41E.8070200@oracle.com>
	 <1323168999-4434-1-git-send-email-annie.li@oracle.com>
 <1323171726.23681.65.camel@zakaz.uk.xensource.com>
 <4EDEDF2E.3040204@oracle.com>
In-Reply-To: <4EDEDF2E.3040204@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB78xvaN020252



> -----Original Message-----
> From: ANNIE LI [mailto:annie.li@oracle.com]
> Sent: 07 December 2011 03:36
> To: Ian Campbell
> Cc: xen-devel@lists.xensource.com; linux-kernel@vger.kernel.org;
> konrad.wilk@oracle.com; jeremy@goop.org; kurt.hackel@oracle.com;
> Paul Durrant
> Subject: Re: [PATCH 1/2] xen/granttable: Support sub-page grants
> 
> Thanks for your reviewing, Ian.
> >>   EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
> >>
> >> +int gnttab_grant_foreign_access_subpage_v2(domid_t domid,
> unsigned long frame,
> >> +					   int flags, unsigned page_off,
> >> +					   unsigned length)
> > Please drop the v2 suffixes on the public functions.
> OK, the initial interface is without v2 suffixes. It was added in
> order to reminder user the interfaces are only available for grant
> table v2.
> But I am fine to remove it, and following ops fn pointers are
> better.
> > Any reason not to route these via the ops table for consistency
> with
> > all the other ops? Then your availability check becomes a test for
> > NULL fn pointer rather than a specific version.
> Ok, it is good.
> How about following implements?
> 
> gnttab_v1_ops = {
>   ...
> .access_subpage = NULL;
> .access_ref_subpage = NULL;
> .access_trans = NULL;
> .access_ref_trans = NULL;
> }
> 
> gnttab_v2_ops = {
>   ...
> .access_subpage = access_subpage_v2;
> .access_ref_subpage = access_ref_subpage_v2; .access_trans =
> access_trans_v2; .access_ref_trans = access_ref_trans_v2; }
> 


Do you need ops for the ref and non-ref functions? I would have thought you could just have the ref ones since the all the non-ref variants do is allocate and then call the ref variant.

  Paul

> gnttab_request_version()
> {
> .....
>     if(v2)
>        gnttab_interface = &gnttab_v2_ops;
>     else
>        gnttab_interface = &gnttab_v1_ops; .....
> }
> 
> int gnttab_grant_foreign_access_subpage()
> {
>        if(gnttab_interface->access_subpage != NULL)
>              return gnttab_interface->access_subpage;
>        return Esomething;
> }
> 
> Same operations for access_ref_subpage, access_trans and
> access_ref_trans.
> 
> bool gnttab_subpage_available()
> {
>       return (gnttab_interface->access_subpage != NULL); }
> 
> bool gnttab_subpage_available()
> {
>       return (gnttab_interface->access_trans != NULL); }
> 
> Thanks
> Annie
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
