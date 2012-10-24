Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161546Ab2JXWcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:32:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34433 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161362Ab2JXWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:32:30 -0400
Date: Wed, 24 Oct 2012 15:32:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: akpm@linux-foundation.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, Jiang Liu <liuj97@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: mmotm 2012-10-22-17-08 uploaded (memory_hotplug.c)
In-Reply-To: <20121023102625.GA24265@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.00.1210241531540.3524@chino.kir.corp.google.com>
References: <20121023000924.C56EF5C0050@hpza9.eem.corp.google.com> <50861FA9.2030506@xenotime.net> <20121023102625.GA24265@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Michal Hocko wrote:

> From e8d79e446b00e57c195c59570df0f2ec435ca39d Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Tue, 23 Oct 2012 11:07:11 +0200
> Subject: [PATCH] mm: make zone_pcp_reset independ on MEMORY_HOTREMOVE
> 
> 340175b7 (mm/hotplug: free zone->pageset when a zone becomes empty)
> introduced zone_pcp_reset and hided it inside CONFIG_MEMORY_HOTREMOVE.
> Since "memory-hotplug: allocate zone's pcp before onlining pages" the
> function is also called from online_pages which is defined outside
> CONFIG_MEMORY_HOTREMOVE which causes a linkage error.
> 
> The function, although not used outside of MEMORY_{HOTPLUT,HOTREMOVE},
> seems like universal enough so let's keep it at its current location
> and only remove the HOTREMOVE guard.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Mel Gorman <mel@csn.ul.ie>

Acked-by: David Rientjes <rientjes@google.com>

This fixes the build error on linux-next of this morning, thanks.
