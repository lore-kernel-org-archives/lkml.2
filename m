Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0JTOfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:35:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56297 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0JTOfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EgsMJFlJQkjgQ90vGAMaleA7OA2wqOcribnqBUeM1ZvKqv5lm06Glzdi4mB5aHcWZQ
         8J8Tr5Ixf9GWEesyBXI4x1SlEiM+Od0RC1suAATlePEqUXJN4Z5SqBlZvp4VToCFgd5J
         r0MVBGhtGez8l99yWJc/TIQ5aL2ZhtgsAYl9Q=
Date: Wed, 20 Oct 2010 23:35:15 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2][memcg+dirtylimit] Fix  overwriting global vm dirty
 limit setting by memcg (Re: [PATCH v3 00/11] memcg: per cgroup dirty page
 accounting
Message-ID: <20101020143515.GB5243@barrios-desktop>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
 <20101020122144.47f2b60b.kamezawa.hiroyu@jp.fujitsu.com>
 <20101020140255.5b8afb63.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020140255.5b8afb63.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 02:02:55PM +0900, KAMEZAWA Hiroyuki wrote:
> Fixed one here.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, at calculating dirty limit, vm_dirty_param() is called.
> This function returns dirty-limit related parameters considering
> memory cgroup settings.
> 
> Now, assume that vm_dirty_bytes=100M (global dirty limit) and
> memory cgroup has 1G of pages and 40 dirty_ratio, dirtyable memory is
> 500MB.
> 
> In this case, global_dirty_limits will consider dirty_limt as
> 500 *0.4 = 200MB. This is bad...memory cgroup is not back door.
> 
> This patch limits the return value of vm_dirty_param() considring
> global settings.
> 
> Changelog:
>  - fixed an argument "mem" int to u64
>  - fixed to use global available memory to cap memcg's value.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

It should have written this on Documentation.
"memcg dirty limit can't exceed global dirty limit"

-- 
Kind regards,
Minchan Kim
