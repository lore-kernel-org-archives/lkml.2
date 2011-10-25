Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab1JYLoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:44:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959Ab1JYLoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:44:11 -0400
Date: Tue, 25 Oct 2011 13:44:06 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5]thp: improve the error code path
Message-ID: <20111025114406.GC10182@redhat.com>
References: <1319511521.22361.135.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319511521.22361.135.camel@sli10-conroe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 25, 2011 at 10:58:41AM +0800, Shaohua Li wrote:
> +#ifdef CONFIG_SYSFS
> +	sysfs_remove_group(hugepage_kobj, &khugepaged_attr_group);
> +remove_hp_group:
> +	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
> +delete_obj:
> +	kobject_put(hugepage_kobj);
>  out:
> +#endif

Adding an ifdef is making the code worse, the whole point of having
these functions become noops at build time is to avoid having to add
ifdefs in the callers.
