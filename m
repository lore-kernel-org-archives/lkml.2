Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab0DHWz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:55:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933734Ab0DHWz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:55:56 -0400
Message-ID: <4BBE5EF0.5000801@infradead.org>
Date: Thu, 08 Apr 2010 19:55:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Michal Simek <monstr@monstr.eu>,
       Johannes Berg <johannes@sipsolutions.net>, Mike Isely <isely@pobox.com>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Anatolij Gustschin <agust@denx.de>,
       Kai Jiang <b18973@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-media@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 2/2] device_attributes: add sysfs_attr_init() for dynamic
 attributes
References: <1270170140-325-1-git-send-email-w.sang@pengutronix.de> <1270170140-325-2-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1270170140-325-2-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang wrote:
> Made necessary by 6992f5334995af474c2b58d010d08bc597f0f2fe. Prevents further
> "key xxx not in .data" bug-reports. Although some attributes could probably be
> converted to static ones, this is left for people having hardware to test.
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
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Greg KH <gregkh@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/macintosh/windfarm_core.c           |    1 +
>  drivers/media/video/pvrusb2/pvrusb2-sysfs.c |    8 ++++++++

I suspect that several (if not all) occurrences at pvrusb2 could be replaced by
static attributes, but let Mike Isely have the final word on that, as the driver
maintainer. From my side, I'm ok with either options.

Cheers,
Mauro
