Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab2JKUcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:32:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2JKUcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:32:00 -0400
Date: Thu, 11 Oct 2012 13:31:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, liuj97@gmail.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, wency@cn.fujitsu.com
Subject: Re: [PATCH 2/2]suppress "Device nodeX does not have a release()
 function" warning
In-Reply-To: <50765896.4000300@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210111326000.28062@chino.kir.corp.google.com>
References: <507656D1.5020703@jp.fujitsu.com> <50765896.4000300@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Yasuaki Ishimatsu wrote:

> When calling unregister_node(), the function shows following message at
> device_release().
> 
> "Device 'node2' does not have a release() function, it is broken and must
> be fixed."
> 
> The reason is node's device struct does not have a release() function.
> 
> So the patch registers node_device_release() to the device's release()
> function for suppressing the warning message. Additionally, the patch adds
> memset() to initialize a node struct into register_node(). Because the node
> struct is part of node_devices[] array and it cannot be freed by
> node_device_release(). So if system reuses the node struct, it has a garbage.
> 

Nice catch on reuse of the statically allocated node_devices[] for node 
hotplug.

> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

Can register_node() be made static in drivers/base/node.c and its 
declaration removed from linux/node.h?

Acked-by: David Rientjes <rientjes@google.com>
