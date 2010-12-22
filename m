Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab0LVIuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:50:03 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25510 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0LVIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:50:01 -0500
X-IronPort-AV: E=Sophos;i="4.60,212,1291611600"; 
   d="scan'208";a="127998536"
Subject: Re: [Xen-devel] [PATCH 05/10] xen/setup: Set identity mapping for
 non-RAM E820 and E820 gaps.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jan Beulich <JBeulich@novell.com>
In-Reply-To: <1292967460-15709-6-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
	 <1292967460-15709-6-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 22 Dec 2010 08:49:33 +0000
Message-ID: <1293007773.3998.38.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 21:37 +0000, Konrad Rzeszutek Wilk wrote:
> @@ -254,6 +282,12 @@ char * __init xen_memory_setup(void)
>  
>         xen_add_extra_mem(extra_pages);
>  
> +       /*
> +        * Set P2M for all non-RAM pages and E820 gaps to be identity
> +        * type PFNs.
> +        */
> +       printk(KERN_INFO "Set %ld page(s) to 1-1 mapping.\n",
> +               xen_set_identity(&e820)); 

I had to look at this patch twice to find the caller of the
xen_set_identity function here. I think spending a variable here would
be worth the improved clarity.

Ian.

