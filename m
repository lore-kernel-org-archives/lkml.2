Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0KDUfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:35:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46370 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab0KDUfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mIuwIwOvREBPEv1Kiu5fOeEiP6hGHeBmRoMtK2eGSGxzTCK/EMGuRI6lZ9Zilflgxc
         YixkX9D3gkNm+o1EvKSbRkaDLdKtwg5gzQVRoReHDNzoQn9h4L0DRe2QBmt4WZ8K4bxg
         VHdqYfytdoMqOCx6KUE1IIEiTz9K1SqZtklVU=
Message-ID: <4CD318F7.8050503@gmail.com>
Date: Fri, 05 Nov 2010 04:35:03 +0800
From: Li Zefan <lizf.kern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101006 Thunderbird/3.1.5
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>,
        Minchan Kim <minchan.kim@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        containers@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] cgroup: prefer [kv]zalloc[_node] over [kv]malloc+memset
 in memory controller code.
References: <alpine.LNX.2.00.1011042104140.15349@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1011042104140.15349@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In mem_cgroup_alloc() we currently do either kmalloc() or vmalloc() then 
> followed by memset() to zero the memory. This can be more efficiently 
> achieved by using kzalloc() and vzalloc().
> There's also one situation where we can use kzalloc_node() - this is 
> what's new in this version of the patch.
> 
> The original patch was:
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>
> Here's version 2. I'd appreciate it if someone could merge it, but I don't 
> know who that someone would be.
> 

Normally it's Andrew Morton.

btw, a better title is: [...] memcgroup: prefer ... over ... memset
