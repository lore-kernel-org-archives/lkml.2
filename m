Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1KRKyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:54:51 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:4043 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1KRKyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:54:51 -0500
X-IronPort-AV: E=Sophos;i="4.69,532,1315180800"; 
   d="scan'208";a="9006394"
Subject: Re: [Xen-devel] [PATCH 1/3] xen/granttable: Introducing grant table
 V2 stucture
From: Ian Campbell <Ian.Campbell@citrix.com>
To: ANNIE LI <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Fri, 18 Nov 2011 10:54:49 +0000
In-Reply-To: <4EC62E77.7090007@oracle.com>
References: <4EC3B62F.6080702@oracle.com>
	 <1321451304-13559-1-git-send-email-annie.li@oracle.com>
	 <4EC62E77.7090007@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1321613689.3664.305.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for splitting these up.

On Fri, 2011-11-18 at 10:07 +0000, ANNIE LI wrote:
> [...]

> return value
> +        * by bit operations.
> +        */
> +       int (*query_foreign_access)(grant_ref_t);
> +};
> +
> +static struct gnttab_ops gnttab_v1_ops;

You don't actually need this forward declaration since the struct
definition and usage are ordered correctly.

> +static struct gnttab_ops gnttab_v1_ops = {
> +       .map_frames                     = gnttab_map_frames_v1,
> +       .unmap_frames                   = gnttab_unmap_frames_v1,
> +       .update_entry                   = update_grant_entry_v1,

Any reason this one is not gnttab_foo?

Ian.


