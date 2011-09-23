Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1IWT2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:28:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1IWT2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:28:02 -0400
Message-ID: <4E7CDDAD.7010704@redhat.com>
Date: Fri, 23 Sep 2011 15:27:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 2/8] kstaled: documentation and config option.
References: <1316230753-8693-1-git-send-email-walken@google.com> <1316230753-8693-3-git-send-email-walken@google.com>
In-Reply-To: <1316230753-8693-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 11:39 PM, Michel Lespinasse wrote:
> Extend memory cgroup documentation do describe the optional idle page
> tracking features, and add the corresponding configuration option.
>
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -370,3 +370,13 @@ config CLEANCACHE
>   	  in a negligible performance hit.
>
>   	  If unsure, say Y to enable cleancache
> +
> +config KSTALED
> +       depends on CGROUP_MEM_RES_CTLR

Looking at patch #3, I wonder if this needs to be dependent
on 64 bit, or at least make sure this is not selected when
a user builds a 32 bit kernel with NUMA.

The reason is that on a 32 bit system we could run out of
page flags + zone bits + node bits.

> +       bool "Per-cgroup idle page tracking"
> +       help
> +         This feature allows the kernel to report the amount of user pages
> +	 in a cgroup that have not been touched in a given time.
> +	 This information may be used to size the cgroups and/or for
> +	 job placement within a compute cluster.
> +	 See Documentation/cgroups/memory.txt for a more complete description.



-- 
All rights reversed
