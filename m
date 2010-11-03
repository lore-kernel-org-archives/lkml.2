Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0KCDEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 23:04:25 -0400
Received: from mail.perches.com ([173.55.12.10]:3933 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab0KCDEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 23:04:23 -0400
Subject: Re: lessen the impact of a deprecated warning in hugetlbfs
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ravikiran G Thirumalai <kiran@scalex86.org>
In-Reply-To: <20101102180622.GA12620@redhat.com>
References: <20101102180622.GA12620@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 20:04:22 -0700
Message-ID: <1288753462.7326.20.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 14:06 -0400, Dave Jones wrote:
> WARN_ONCE is a bit strong for a deprecation warning, given that it spews a
> huge backtrace.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> --- linux-2.6.36.noarch/fs/hugetlbfs/inode.c~	2010-11-02 14:01:19.489289082 -0400
> +++ linux-2.6.36.noarch/fs/hugetlbfs/inode.c	2010-11-02 14:02:19.947986439 -0400
> @@ -915,8 +915,7 @@ struct file *hugetlb_file_setup(const ch
>  	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
>  		*user = current_user();
>  		if (user_shm_lock(size, *user)) {
> -			WARN_ONCE(1,
> -			  "Using mlock ulimits for SHM_HUGETLB deprecated\n");
> +			printk_once("Using mlock ulimits for SHM_HUGETLB deprecated\n");

Please add a KERN_NOTICE or similar.
The grammar could be improved via "is deprecated"


