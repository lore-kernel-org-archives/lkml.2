Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab1ECQf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:35:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53507 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1ECQfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:35:55 -0400
Subject: Re: [PATCH V2] xen/balloon: Memory hotplug support for Xen balloon
 driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110502220148.GI4623@router-fw-old.local.net-space.pl>
References: <20110502220148.GI4623@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 03 May 2011 09:32:33 -0700
Message-ID: <1304440353.30823.73.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 00:01 +0200, Daniel Kiper wrote:
> @@ -448,6 +575,14 @@ static int __init balloon_init(void)
>         balloon_stats.retry_count = 1;
>         balloon_stats.max_retry_count = RETRY_UNLIMITED;
> 
> +#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
> +       balloon_stats.hotplug_pages = 0;
> +       balloon_stats.balloon_hotplug = 0;
> +
> +       register_online_page_callback(&xen_online_page);
> +       register_memory_notifier(&xen_memory_nb);
> +#endif 

This is 100% static, apparently.  XEN_BALLOON can't be a module, so I
still don't see the point of having the un/register stuff.  

-- Dave


