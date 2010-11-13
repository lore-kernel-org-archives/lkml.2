Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0KMDFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:05:12 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:60702 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0KMDFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:05:08 -0500
X-Greylist: delayed 4251 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 22:05:08 EST
Date: Fri, 12 Nov 2010 17:54:13 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lessen the impact of a deprecated warning in hugetlbfs
Message-ID: <20101113015413.GA2237@dogmatix.scalempus>
References: <20101102180622.GA12620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101102180622.GA12620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was to be deprecated by 2.6.31. It is better to kill it I think.

Thanks,
Kiran

On Tue, Nov 02, 2010 at 02:06:22PM -0400, Dave Jones wrote:
>WARN_ONCE is a bit strong for a deprecation warning, given that it spews a
>huge backtrace.
>
>Signed-off-by: Dave Jones <davej@redhat.com>
>
>--- linux-2.6.36.noarch/fs/hugetlbfs/inode.c~	2010-11-02 14:01:19.489289082 -0400
>+++ linux-2.6.36.noarch/fs/hugetlbfs/inode.c	2010-11-02 14:02:19.947986439 -0400
>@@ -915,8 +915,7 @@ struct file *hugetlb_file_setup(const ch
> 	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
> 		*user = current_user();
> 		if (user_shm_lock(size, *user)) {
>-			WARN_ONCE(1,
>-			  "Using mlock ulimits for SHM_HUGETLB deprecated\n");
>+			printk_once("Using mlock ulimits for SHM_HUGETLB deprecated\n");
> 		} else {
> 			*user = NULL;
> 			return ERR_PTR(-EPERM);
