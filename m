Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2LNJjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:39:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53021 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2LNJjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:39:09 -0500
X-IronPort-AV: E=Sophos;i="4.84,280,1355068800"; 
   d="scan'208";a="6399272"
Message-ID: <50CAF3C9.3090906@cn.fujitsu.com>
Date: Fri, 14 Dec 2012 17:39:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, akpm@linux-foundation.org
CC: isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        mel@csn.ul.ie, wency@cn.fujitsu.com, mingo@elte.hu, penberg@kernel.org,
        torvalds@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memory-hotplug: Add help info for CONFIG_MOVABLE_NODE
 option
References: <1355477270-19922-1-git-send-email-tangchen@cn.fujitsu.com> <1355477270-19922-2-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1355477270-19922-2-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/14 17:38:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/14 17:38:15,
	Serialize complete at 2012/12/14 17:38:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 05:27 PM, Tang Chen wrote:
> This patch adds help info for CONFIG_MOVABLE_NODE option.
> 
> This option allows user to online all memory of a node as movable
> memory. So that the whole node can be hotpluged. Users who don't
> use hotplug feature are also fine with this option on since they
> won't online memory as movable.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>  mm/Kconfig |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 71259e0..2ad51cb 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -150,6 +150,16 @@ config MOVABLE_NODE
>  	depends on X86_64
>  	depends on NUMA
>  	depends on BROKEN
> +	help
> +	  Allow a node to have only movable memory. Pages used by kernel, such
> +	  as direct mapping pages can not be migrated. So the corresponding
> +	  memory device can not be hotpluged. This option allows users to
> +	  online all the memory of a node as movable memory so that the whole
> +	  node can be hotpluged. Users who don't use hotplug feature are fine
> +	  with this option on since they don't online memory as movable.
> +
> +	  Say Y here if you want to hotplug a whole node.
> +	  Say N here if you want kernel to use memory on all nodes evenly.

Thank you for adding the help text which should have been done by me.

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
