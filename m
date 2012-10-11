Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab2JKWbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:31:15 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42758 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab2JKWbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:31:11 -0400
MIME-Version: 1.0
In-Reply-To: <50765797.3080709@jp.fujitsu.com>
References: <507656D1.5020703@jp.fujitsu.com> <50765797.3080709@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 11 Oct 2012 18:30:50 -0400
X-Google-Sender-Auth: GHx91D6sAvzzpmkEJEeg-neVCIc
Message-ID: <CAHGf_=ph2RGaZz137Y=_GpH6sFMuHHt3vCq3vfB-Ozfd1Cteiw@mail.gmail.com>
Subject: Re: [PATCH 1/2]suppress "Device memoryX does not have a release()
 function" warning
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, minchan.kim@gmail.com, akpm@linux-foundation.org,
        wency@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 1:22 AM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
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

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
