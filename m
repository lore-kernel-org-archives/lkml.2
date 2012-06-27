Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab2F0E3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 00:29:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63033 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2F0E3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 00:29:14 -0400
Date: Tue, 26 Jun 2012 21:29:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>
cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 8/8] release memory resources if hotadd_new_pgdat()
 failed
In-Reply-To: <4FE97F7B.2030808@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206262128140.24245@chino.kir.corp.google.com>
References: <4FE97DD5.6030205@cn.fujitsu.com> <4FE97F7B.2030808@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Wen Congyang wrote:

> We should goto error to release memory resource if hotadd_new_pgdat() failed.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  mm/memory_hotplug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 2a14d35..3796690 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -617,7 +617,7 @@ int __ref add_memory(int nid, u64 start, u64 size)
>  		pgdat = hotadd_new_pgdat(nid, start);
>  		ret = -ENOMEM;
>  		if (!pgdat)
> -			goto out;
> +			goto error;
>  		new_pgdat = 1;
>  	}
>  

This is a generic memory hotplug patch and doesn't rely on the rest of the 
series, so let's cc the maintainer, Andrew Morton 
<akpm@linux-foundation.org>.

Acked-by: David Rientjes <rientjes@google.com>
