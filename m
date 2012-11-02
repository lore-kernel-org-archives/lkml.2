Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934876Ab2KBSkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:40:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26544 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2KBSkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:40:14 -0400
Date: Fri, 2 Nov 2012 14:39:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org, fschmaus@gmail.com,
        andor.damm@googlemail.com, ilendir@googlemail.com,
        akpm@linux-foundation.org, mgorman@suse.de
Subject: Re: [PATCH 3/5] staging: zcache2+ramster: enable zcache2 to be
 built/loaded as a module
Message-ID: <20121102183950.GD30100@konrad-lan.dumpdata.com>
References: <1351696074-29362-1-git-send-email-dan.magenheimer@oracle.com>
 <1351696074-29362-4-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351696074-29362-4-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 08:07:52AM -0700, Dan Magenheimer wrote:
> Allow zcache2 to be built/loaded as a module.  Note runtime dependency
> disallows loading if cleancache/frontswap lazy initialization patches
> are not present.  Zsmalloc support has not yet been merged into zcache2
> but, once merged, could now easily be selected via a module_param.
> 
> If built-in (not built as a module), the original mechanism of enabling via
> a kernel boot parameter is retained, but this should be considered deprecated.
> 
> Note that module unload is explicitly not yet supported.

I had an issue putting it on v3.7-rc3 with the Kconfig. Not sure why
as it looks exactly the same.

The patch looks good, however..

> @@ -1812,9 +1846,28 @@ static int __init zcache_init(void)
>  	}
>  	if (ramster_enabled)
>  		ramster_init(!disable_cleancache, !disable_frontswap,
> -				frontswap_has_exclusive_gets);
> +				frontswap_has_exclusive_gets,
> +				!disable_frontswap_selfshrink);
>  out:
>  	return ret;
>  }

.. ramster_init change is in the next patch. So it looks like the
patch order is a bit mismatched.

