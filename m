Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab2JKUXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:23:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43094 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2JKUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:23:52 -0400
Date: Thu, 11 Oct 2012 13:23:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, liuj97@gmail.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, wency@cn.fujitsu.com
Subject: Re: [PATCH 1/2]suppress "Device memoryX does not have a release()
 function" warning
In-Reply-To: <50765797.3080709@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210111323370.28062@chino.kir.corp.google.com>
References: <507656D1.5020703@jp.fujitsu.com> <50765797.3080709@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Yasuaki Ishimatsu wrote:

> When calling remove_memory_block(), the function shows following message at
> device_release().
> 
> "Device 'memory528' does not have a release() function, it is broken and must
> be fixed."
> 
> The reason is memory_block's device struct does not have a release() function.
> 
> So the patch registers memory_block_release() to the device's release() function
> for suppressing the warning message. Additionally, the patch moves kfree(mem)
> into the release function since the release function is prepared as a means
> to free a memory_block struct.
> 
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
