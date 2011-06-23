Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab1FWBfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:35:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46950 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab1FWBfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:35:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E02983F.4020408@jp.fujitsu.com>
Date: Thu, 23 Jun 2011 10:34:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: rientjes@google.com
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 2/2] mm, hotplug: protect zonelist building with zonelists_mutex
References: <alpine.DEB.2.00.1106221810130.23120@chino.kir.corp.google.com> <alpine.DEB.2.00.1106221811500.23120@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106221811500.23120@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/23 10:13), David Rientjes wrote:
> 959ecc48fc75 ("mm/memory_hotplug.c: fix building of node hotplug 
> zonelist") does not protect the build_all_zonelists() call with 
> zonelists_mutex as needed.  This can lead to races in constructing 
> zonelist ordering if a concurrent build is underway.  Protecting this with 
> lock_memory_hotplug() is insufficient since zonelists can be rebuild 
> though sysfs as well.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Indeed.

 Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> ---
>  mm/memory_hotplug.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -498,7 +498,9 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
>  	 * The node we allocated has no zone fallback lists. For avoiding
>  	 * to access not-initialized zonelist, build here.
>  	 */
> +	mutex_lock(&zonelists_mutex);
>  	build_all_zonelists(NULL);
> +	mutex_unlock(&zonelists_mutex);
>  
>  	return pgdat;
>  }
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 


