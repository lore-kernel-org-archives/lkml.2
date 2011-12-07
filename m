Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1LGJ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:56:26 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:37713 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1LGJ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:56:25 -0500
X-IronPort-AV: E=Sophos;i="4.71,313,1320624000"; 
   d="scan'208";a="9336749"
Subject: Re: [PATCH 1/2] xen/granttable: Support sub-page grants
From: Ian Campbell <Ian.Campbell@citrix.com>
To: ANNIE LI <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Date: Wed, 7 Dec 2011 09:56:23 +0000
In-Reply-To: <4EDEDF2E.3040204@oracle.com>
References: <4EDDF41E.8070200@oracle.com>
	 <1323168999-4434-1-git-send-email-annie.li@oracle.com>
	 <1323171726.23681.65.camel@zakaz.uk.xensource.com>
	 <4EDEDF2E.3040204@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323251784.23681.126.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 03:36 +0000, ANNIE LI wrote:
> Thanks for your reviewing, Ian.
> >>   EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
> >>
> >> +int gnttab_grant_foreign_access_subpage_v2(domid_t domid, unsigned long frame,
> >> +					   int flags, unsigned page_off,
> >> +					   unsigned length)
> > Please drop the v2 suffixes on the public functions.
> OK, the initial interface is without v2 suffixes. It was added in order 
> to reminder user the interfaces are only available for grant table v2.
> But I am fine to remove it, and following ops fn pointers are better.
> > Any reason not to route these via the ops table for consistency with all
> > the other ops? Then your availability check becomes a test for NULL fn
> > pointer rather than a specific version.
> Ok, it is good.
> How about following implements?

Looks to be along the right lines. Thanks.

> gnttab_v1_ops = {
>   ...
> .access_subpage = NULL;
> .access_ref_subpage = NULL;
> .access_trans = NULL;
> .access_ref_trans = NULL;
> }

I think you can omit these since NULL is the default but perhaps
explicitly listing them is useful in a self documenting type way.

[...]
> 
> Same operations for access_ref_subpage, access_trans and access_ref_trans.
> 
> bool gnttab_subpage_available()
> {
>       return (gnttab_interface->access_subpage != NULL);
> }
> 
> bool gnttab_subpage_available()
Typo:       ..trans..
> {
>       return (gnttab_interface->access_trans != NULL);
> }

Ian.

> 
> Thanks
> Annie


