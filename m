Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2JMM0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 08:26:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36038 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2JMM0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 08:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <1349999637-8613-1-git-send-email-andi@firstfloor.org>
References: <1349999637-8613-1-git-send-email-andi@firstfloor.org>
Date: Sat, 13 Oct 2012 20:26:39 +0800
Message-ID: <CAJd=RBByzsGUaOxOoQpu_SN+K5XRxd2PEGhB48CHkuO5qJ5grA@mail.gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v4
From: Hillf Danton <dhillf@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, Oct 12, 2012 at 7:53 AM, Andi Kleen <andi@firstfloor.org> wrote:
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 2251648..c626a2a 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -183,7 +183,13 @@ extern const struct file_operations hugetlbfs_file_operations;
>  extern const struct vm_operations_struct hugetlb_vm_ops;
>  struct file *hugetlb_file_setup(const char *name, unsigned long addr,
>                                 size_t size, vm_flags_t acct,
> -                               struct user_struct **user, int creat_flags);
> +                               struct user_struct **user, int creat_flags,
> +                               int page_size_log);
> +int hugetlb_get_quota(struct address_space *mapping, long delta);
> +void hugetlb_put_quota(struct address_space *mapping, long delta);
> +
> +int hugetlb_get_quota(struct address_space *mapping, long delta);
> +void hugetlb_put_quota(struct address_space *mapping, long delta);


For what to add(twice) hugetlb_get/put_quota?

Hillf
