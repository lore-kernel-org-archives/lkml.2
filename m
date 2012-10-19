Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2JSGyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:54:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63514 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2JSGyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <1350629202-9664-3-git-send-email-wency@cn.fujitsu.com>
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com> <1350629202-9664-3-git-send-email-wency@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 02:53:56 -0400
X-Google-Sender-Auth: xGqSXfui-uk97YQBoMZ5-ZLEReI
Message-ID: <CAHGf_=r017AX=mcTNj=XEnTReuwpJgyKWz-f4i=2bVOt7E0udQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] suppress "Device nodeX does not have a release()
 function" warning
To: wency@cn.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 2:46 AM,  <wency@cn.fujitsu.com> wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
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
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

I still think node array should be converted node pointer array and
node_device_release() free memory as other typical drivers.
However, this is acceptable as first step.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
