Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030730Ab2CNQj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:39:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41527 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2CNQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:39:26 -0400
Date: Wed, 14 Mar 2012 12:35:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
        xen-devel <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] xen: constify all instances of "struct
 attribute_group"
Message-ID: <20120314163517.GF16960@phenom.dumpdata.com>
References: <4F4786FD0200007800074A0C@nat28.tlf.novell.com>
 <20120226160230.GA2274@phenom.dumpdata.com>
 <4F4B4C9D0200007800074E09@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4B4C9D0200007800074E09@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F60C9B9.0088,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 08:27:57AM +0000, Jan Beulich wrote:
> >>> On 26.02.12 at 17:02, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Fri, Feb 24, 2012 at 11:47:57AM +0000, Jan Beulich wrote:
> >> The functions these get passed to have been taking pointers to const
> >> since at least 2.6.16.
> > 
> > What is this based on? I get:
> 
> Plain 3.3-rc4.
> 
> > HEAD is now at b01543d... Linux 3.3-rc4
> > konrad@phenom:~/ssd/linux$ patch -p1 < /tmp/jan-1
> > patching file drivers/xen/sys-hypervisor.c
> > Hunk #1 FAILED at 97.
> > Hunk #2 FAILED at 210.
> > Hunk #3 FAILED at 340.
> > 3 out of 3 hunks FAILED -- saving rejects to file 
> > drivers/xen/sys-hypervisor.c.rej
> > patching file drivers/xen/xen-balloon.c
> > Hunk #1 FAILED at 207.
> > 1 out of 1 hunk FAILED -- saving rejects to file drivers/xen/xen-balloon.c.rej
> > patching file drivers/xen/xen-selfballoon.c
> > Hunk #1 FAILED at 488.
> > 1 out of 1 hunk FAILED -- saving rejects to file 
> > drivers/xen/xen-selfballoon.c.rej
> 
> Is /tmp/jan-1 perhaps suffering whitespace corruption (which would
> have happened at your end, as I can take the tail of your response,
> remove the reply quotation, and apply it successfully), even though
> I don't think we had problems of this kind in the past? I'll attach the
> patch here, just in case.

Thanks. Used the attached patch and it applied nicely. 
> 
> Jan
> 
> >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >> 
> >> ---
> >>  drivers/xen/sys-hypervisor.c  |    6 +++---
> >>  drivers/xen/xen-balloon.c     |    2 +-
> >>  drivers/xen/xen-selfballoon.c |    2 +-
> >>  3 files changed, 5 insertions(+), 5 deletions(-)
> >> 
> >> --- 3.3-rc4/drivers/xen/sys-hypervisor.c
> >> +++ 3.3-rc4-xen-const-attribute_group/drivers/xen/sys-hypervisor.c
> >> @@ -97,7 +97,7 @@ static struct attribute *version_attrs[]
> >>  	NULL
> >>  };
> >>  
> >> -static struct attribute_group version_group = {
> >> +static const struct attribute_group version_group = {
> >>  	.name = "version",
> >>  	.attrs = version_attrs,
> >>  };
> >> @@ -210,7 +210,7 @@ static struct attribute *xen_compile_att
> >>  	NULL
> >>  };
> >>  
> >> -static struct attribute_group xen_compilation_group = {
> >> +static const struct attribute_group xen_compilation_group = {
> >>  	.name = "compilation",
> >>  	.attrs = xen_compile_attrs,
> >>  };
> >> @@ -340,7 +340,7 @@ static struct attribute *xen_properties_
> >>  	NULL
> >>  };
> >>  
> >> -static struct attribute_group xen_properties_group = {
> >> +static const struct attribute_group xen_properties_group = {
> >>  	.name = "properties",
> >>  	.attrs = xen_properties_attrs,
> >>  };
> >> --- 3.3-rc4/drivers/xen/xen-balloon.c
> >> +++ 3.3-rc4-xen-const-attribute_group/drivers/xen/xen-balloon.c
> >> @@ -207,7 +207,7 @@ static struct attribute *balloon_info_at
> >>  	NULL
> >>  };
> >>  
> >> -static struct attribute_group balloon_info_group = {
> >> +static const struct attribute_group balloon_info_group = {
> >>  	.name = "info",
> >>  	.attrs = balloon_info_attrs
> >>  };
> >> --- 3.3-rc4/drivers/xen/xen-selfballoon.c
> >> +++ 3.3-rc4-xen-const-attribute_group/drivers/xen/xen-selfballoon.c
> >> @@ -488,7 +488,7 @@ static struct attribute *selfballoon_att
> >>  	NULL
> >>  };
> >>  
> >> -static struct attribute_group selfballoon_group = {
> >> +static const struct attribute_group selfballoon_group = {
> >>  	.name = "selfballoon",
> >>  	.attrs = selfballoon_attrs
> >>  };
> >> 
> >> 
> 
> 
> 

> xen: constify all instances of "struct attribute_group"
> 
> The functions these get passed to have been taking pointers to const
> since at least 2.6.16.
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

> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

