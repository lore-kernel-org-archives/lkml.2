Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0ITTY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:24:26 -0400
Received: from waste.org ([173.11.57.241]:39363 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab0ITTYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:24:25 -0400
Subject: Re: [PATCH v2] Document the new Anonymous field in smaps.
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hughd@google.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Richard Guenther <rguenther@suse.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LSU.2.00.1009200003150.4348@sister.anvils>
References: <AANLkTini3k1hK-9RM6io0mOf4VoDzGpbUEpiv=WHfhEW@mail.gmail.com>
	 <201009161135.00129.knikanth@suse.de>
	 <alpine.DEB.2.00.1009160940330.24798@tigran.mtv.corp.google.com>
	 <201009171134.02771.knikanth@suse.de>
	 <alpine.LSU.2.00.1009200003150.4348@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 14:24:20 -0500
Message-ID: <1285010660.21906.905.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 00:11 -0700, Hugh Dickins wrote:
> On Fri, 17 Sep 2010, Nikanth Karthikesan wrote:
> > Document the new Anonymous field in smaps.
> 
> Thanks for doing that, good effort, but your shifts between singular
> and plural rather jarred on my ear, so I've rewritten it a little below.
> Also added a sentence on "Swap"; but gave up when it came to KernelPageSize
> and MMUPageSize, let someone else clarify those later.
> 
> 
> [PATCH v3] Document the new Anonymous field in smaps.
> 
> From: Nikanth Karthikesan <knikanth@suse.de>
> 
> Document the new Anonymous field in smaps, and also the Swap field.
> Explain what smaps means by shared and private, which differs from
> MAP_SHARED and MAP_PRIVATE.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> Signed-off-by: Hugh Dickins <hughd@google.com>

Looks good, 

Acked-by: Matt Mackall <mpm@selenic.com>

> ---
> 
>  Documentation/filesystems/proc.txt |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -370,17 +370,24 @@ Shared_Dirty:          0 kB
>  Private_Clean:         0 kB
>  Private_Dirty:         0 kB
>  Referenced:          892 kB
> +Anonymous:             0 kB
>  Swap:                  0 kB
>  KernelPageSize:        4 kB
>  MMUPageSize:           4 kB
>  
> -The first  of these lines shows  the same information  as is displayed for the
> -mapping in /proc/PID/maps.  The remaining lines show  the size of the mapping,
> +The first of these lines shows the same information as is displayed for the
> +mapping in /proc/PID/maps. The remaining lines show the size of the mapping,
>  the amount of the mapping that is currently resident in RAM, the "proportional
>  set size” (divide each shared page by the number of processes sharing it), the
>  number of clean and dirty shared pages in the mapping, and the number of clean
> -and dirty private pages in the mapping.  The "Referenced" indicates the amount
> -of memory currently marked as referenced or accessed.
> +and dirty private pages in the mapping. Note that even a page which is part of
> +a MAP_SHARED mapping, but has only a single pte mapped, i.e. is currently used
> +by only one process, is accounted as private and not as shared. "Referenced"
> +indicates the amount of memory currently marked as referenced or accessed.
> +"Anonymous" shows the amount of memory that does not belong to any file. Even
> +a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
> +and a page is modified, the file page is replaced by a private anonymous copy.
> +"Swap" shows how much would-be-anonymous memory is also used, but out on swap.
>  
>  This file is only present if the CONFIG_MMU kernel configuration option is
>  enabled.


-- 
Mathematics is the supreme nostalgia of our time.


