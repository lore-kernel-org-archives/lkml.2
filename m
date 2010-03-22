Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0CVGkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 02:40:37 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37836 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0CVGkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 02:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YI/id8NlWNQHEjHvT280sf5DNUSMW85AA3jZyi6pKsE+e5WPN5/MT/G3XtaT23fLch
         24a/QgHAax4iWtkkMTccGb9lXMx3DHQwhms5HOCtBGxAZkLzGTpzWo4E7sYA14z69adm
         cv7W2WE1VLCz4jnoBnFwYfnrOOKHzZElgivbg=
Date: Sun, 21 Mar 2010 23:40:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] device_attributes: add sysfs_attr_init() for dynamic
 attributes
Message-ID: <20100322064027.GG31621@core.coreip.homeip.net>
References: <1269238878-991-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269238878-991-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Mon, Mar 22, 2010 at 07:21:17AM +0100, Wolfram Sang wrote:
> Made necessary by 6992f5334995af474c2b58d010d08bc597f0f2fe.
> 
> Found by this semantic patch:
> 
> @ init @
> type T;
> identifier A;
> @@
> 
>         T {
>                 ...
>                 struct device_attribute A;
>                 ...
>         };
> 
> @ main extends init @
> expression E;
> statement S;
> identifier err;
> T *name;
> @@
> 
>         ... when != sysfs_attr_init(&name->A.attr);
> (
> +       sysfs_attr_init(&name->A.attr);
>         if (device_create_file(E, &name->A))
>                 S
> |
> +       sysfs_attr_init(&name->A.attr);
>         err = device_create_file(E, &name->A);
> )
> 
> While reviewing, I put the initialization to apropriate places.
> 

My standard question - are all of these need to be dynamically
allocated?

Thanks.

-- 
Dmitry
