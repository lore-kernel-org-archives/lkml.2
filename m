Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2BZQGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 11:06:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45168 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2BZQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 11:06:13 -0500
Date: Sun, 26 Feb 2012 11:02:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel <xen-devel@lists.xen.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: constify all instances of "struct attribute_group"
Message-ID: <20120226160230.GA2274@phenom.dumpdata.com>
References: <4F4786FD0200007800074A0C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4786FD0200007800074A0C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F4A586D.0052,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 11:47:57AM +0000, Jan Beulich wrote:
> The functions these get passed to have been taking pointers to const
> since at least 2.6.16.

What is this based on? I get:

HEAD is now at b01543d... Linux 3.3-rc4
konrad@phenom:~/ssd/linux$ patch -p1 < /tmp/jan-1
patching file drivers/xen/sys-hypervisor.c
Hunk #1 FAILED at 97.
Hunk #2 FAILED at 210.
Hunk #3 FAILED at 340.
3 out of 3 hunks FAILED -- saving rejects to file drivers/xen/sys-hypervisor.c.rej
patching file drivers/xen/xen-balloon.c
Hunk #1 FAILED at 207.
1 out of 1 hunk FAILED -- saving rejects to file drivers/xen/xen-balloon.c.rej
patching file drivers/xen/xen-selfballoon.c
Hunk #1 FAILED at 488.
1 out of 1 hunk FAILED -- saving rejects to file drivers/xen/xen-selfballoon.c.rej


> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  drivers/xen/sys-hypervisor.c  |    6 +++---
>  drivers/xen/xen-balloon.c     |    2 +-
>  drivers/xen/xen-selfballoon.c |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> --- 3.3-rc4/drivers/xen/sys-hypervisor.c
> +++ 3.3-rc4-xen-const-attribute_group/drivers/xen/sys-hypervisor.c
> @@ -97,7 +97,7 @@ static struct attribute *version_attrs[]
>  	NULL
>  };
>  
> -static struct attribute_group version_group = {
> +static const struct attribute_group version_group = {
>  	.name = "version",
>  	.attrs = version_attrs,
>  };
> @@ -210,7 +210,7 @@ static struct attribute *xen_compile_att
>  	NULL
>  };
>  
> -static struct attribute_group xen_compilation_group = {
> +static const struct attribute_group xen_compilation_group = {
>  	.name = "compilation",
>  	.attrs = xen_compile_attrs,
>  };
> @@ -340,7 +340,7 @@ static struct attribute *xen_properties_
>  	NULL
>  };
>  
> -static struct attribute_group xen_properties_group = {
> +static const struct attribute_group xen_properties_group = {
>  	.name = "properties",
>  	.attrs = xen_properties_attrs,
>  };
> --- 3.3-rc4/drivers/xen/xen-balloon.c
> +++ 3.3-rc4-xen-const-attribute_group/drivers/xen/xen-balloon.c
> @@ -207,7 +207,7 @@ static struct attribute *balloon_info_at
>  	NULL
>  };
>  
> -static struct attribute_group balloon_info_group = {
> +static const struct attribute_group balloon_info_group = {
>  	.name = "info",
>  	.attrs = balloon_info_attrs
>  };
> --- 3.3-rc4/drivers/xen/xen-selfballoon.c
> +++ 3.3-rc4-xen-const-attribute_group/drivers/xen/xen-selfballoon.c
> @@ -488,7 +488,7 @@ static struct attribute *selfballoon_att
>  	NULL
>  };
>  
> -static struct attribute_group selfballoon_group = {
> +static const struct attribute_group selfballoon_group = {
>  	.name = "selfballoon",
>  	.attrs = selfballoon_attrs
>  };
> 
> 
