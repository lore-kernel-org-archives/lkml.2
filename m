Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0JVDZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 23:25:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37029 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0JVDZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 23:25:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 22 Oct 2010 12:20:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] nommu: add anonymous page memcg accounting
Message-Id: <20101022122010.793bebac.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287664088-4483-1-git-send-email-steve@digidescorp.com>
References: <1287664088-4483-1-git-send-email-steve@digidescorp.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 07:28:08 -0500
"Steven J. Magnani" <steve@digidescorp.com> wrote:

> Add the necessary calls to track VM anonymous page usage (only).
> 
> V3 changes:
> * Use vma->vm_mm instead of current->mm when charging pages, for clarity
> * Document that reclaim is not possible with only anonymous page accounting
>   so the OOM-killer is invoked when a limit is exceeded
> * Add TODO to implement file cache (reclaim) support or optimize away
>   page_cgroup->lru
> 
> V2 changes:
> * Added update of memory cgroup documentation
> * Clarify use of 'file' to distinguish anonymous mappings
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>

Thanks,

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

BTW, have you tried oom_notifier+NOMMU memory limit oom-killer ?
It may be a chance to implement a custom OOM-Killer in userland on
EMBEDED systems.

Thanks,
-Kame

