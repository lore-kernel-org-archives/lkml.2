Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab0LTOwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:52:46 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:54758 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0LTOwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:52:45 -0500
X-IronPort-AV: E=Sophos;i="4.60,202,1291611600"; 
   d="scan'208";a="127698439"
Subject: Re: [Xen-devel] [PATCH 2/3] drivers/xen/balloon.c: Various balloon
 features and fixes
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Daniel Kiper <dkiper@net-space.pl>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20101220134724.GC6749@router-fw-old.local.net-space.pl>
References: <20101220134724.GC6749@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 20 Dec 2010 14:51:44 +0000
Message-ID: <1292856704.4500.249.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 13:47 +0000, Daniel Kiper wrote:
> Features and fixes:
>   - HVM mode is supported now,
>   - migration from mod_timer() to schedule_delayed_work(),
>   - removal of driver_pages (I do not have seen any
>     references to it),
>   - protect before CPU exhaust by event/x process during
>     errors by adding some delays in scheduling next event,
>   - some other minor fixes.

Each of those bullets should be a separate patch (or several if
appropriate). I didn't review most of the rest because it mixed so much
stuff together but a couple of minor things jumped out.

> -static void scrub_page(struct page *page)
> +static inline void scrub_page(struct page *page)

Is there some reason we need to override the compiler's decision here?
There is some discussion of the (over)use of inline in CodingStyle.

>  static struct attribute_group balloon_info_group = {
>         .name = "info",
> -       .attrs = balloon_info_attrs,
> +       .attrs = balloon_info_attrs
>  };
> 
>  static struct sysdev_class balloon_sysdev_class = {
> -       .name = BALLOON_CLASS_NAME,
> +       .name = BALLOON_CLASS_NAME
>  };

I don't think there is anything wrong with the existing style here.

Ian.


