Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330Ab2KAVgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:36:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53611 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762288Ab2KAVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:36:16 -0400
Date: Thu, 1 Nov 2012 14:36:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wen Congyang <wency@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PART3 Patch 00/14] introduce N_MEMORY
In-Reply-To: <509212FC.8070802@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1211011431130.19373@chino.kir.corp.google.com>
References: <1351670652-9932-1-git-send-email-wency@cn.fujitsu.com> <alpine.DEB.2.00.1210311112010.8809@chino.kir.corp.google.com> <509212FC.8070802@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Wen Congyang wrote:

> > This doesn't describe why we need the new node state, unfortunately.  It 
> 
> 1. Somethimes, we use the node which contains the memory that can be used by
>    kernel.
> 2. Sometimes, we use the node which contains the memory.
> 
> In case1, we use N_HIGH_MEMORY, and we use N_MEMORY in case2.
> 

Yeah, that's clear, but the question is still _why_ we want two different 
nodemasks.  I know that this part of the patchset simply introduces the 
new nodemask because the name "N_MEMORY" is more clear than 
"N_HIGH_MEMORY", but there's no real incentive for making that change by 
introducing a new nodemask where a simple rename would suffice.

I can only assume that you want to later use one of them for a different 
purpose: those that do not include nodes that consist of only 
ZONE_MOVABLE.  But that change for MPOL_BIND is nacked since it 
significantly changes the semantics of set_mempolicy() and you can't break 
userspace (see my response to that from yesterday).  Until that problem is 
addressed, then there's no reason for the additional nodemask so nack on 
this series as well.
