Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0ETXtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:49:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40370 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0ETXtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:49:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: lwoodman@redhat.com
Subject: Re: RFC: dirty_ratio back to 40%
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <npiggin@suse.de>,
       Jan Kara <jack@suse.cz>
In-Reply-To: <4BF51B0A.1050901@redhat.com>
References: <4BF51B0A.1050901@redhat.com>
Message-Id: <20100521083408.1E36.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 21 May 2010 08:48:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

CC to Nick and Jan

> We've seen multiple performance regressions linked to the lower(20%)
> dirty_ratio.  When performing enough IO to overwhelm the background  
> flush daemons the percent of dirty pagecache memory quickly climbs 
> to the new/lower dirty_ratio value of 20%.  At that point all writing 
> processes are forced to stop and write dirty pagecache pages back to disk.  
> This causes performance regressions in several benchmarks as well as causing
> a noticeable overall sluggishness.  We all know that the dirty_ratio is
> an integrity vs performance trade-off but the file system journaling
> will cover any devastating effects in the event of a system crash.
> 
> Increasing the dirty_ratio to 40% will regain the performance loss seen
> in several benchmarks.  Whats everyone think about this???

In past, Jan Kara also claim the exactly same thing.

	Subject: [LSF/VM TOPIC] Dynamic sizing of dirty_limit
	Date: Wed, 24 Feb 2010 15:34:42 +0100

	> (*) We ended up increasing dirty_limit in SLES 11 to 40% as it used to be
	> with old kernels because customers running e.g. LDAP (using BerkelyDB
	> heavily) were complaining about performance problems.

So, I'd prefer to restore the default rather than both Redhat and SUSE apply exactly
same distro specific patch. because we can easily imazine other users will face the same
issue in the future.

	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Nick, Jan, if the above is too old and your distro have been dropped the patch, please
correct me.

My motivation is, distro specific patches should keep minimum as far as possible.
It exactly help I and other MM developers handle MM bug report.

Thanks.


> ------------------------------------------------------------------------
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index ef27e73..645a462 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -78,7 +78,7 @@ int vm_highmem_is_dirtyable;
>  /*
>   * The generator of dirty data starts writeback at this percentage
>   */
> -int vm_dirty_ratio = 20;
> +int vm_dirty_ratio = 40;
>  
>  /*
>   * vm_dirty_bytes starts at 0 (disabled) so that it is a function of
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



