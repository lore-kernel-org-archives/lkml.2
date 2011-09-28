Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1I1GJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:09:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44999 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1I1GJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:09:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 15:08:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V10 5/6] mm: cleancache: update to match akpm frontswap
 feedback
Message-Id: <20110928150841.fbe661fe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110915213446.GA26406@ca-server1.us.oracle.com>
References: <20110915213446.GA26406@ca-server1.us.oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011 14:34:46 -0700
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Subject: [PATCH V10 5/6] mm: cleancache: update to match akpm frontswap feedback
	err = sysfs_create_group(mm_kobj, &cleancache_attr_group);
> -#endif /* CONFIG_SYSFS */
> +#ifdef CONFIG_DEBUG_FS
> +	struct dentry *root = debugfs_create_dir("cleancache", NULL);
> +	if (root == NULL)
> +		return -ENXIO;
> +	debugfs_create_u64("succ_gets", S_IRUGO, root, &cleancache_succ_gets);
> +	debugfs_create_u64("failed_gets", S_IRUGO,
> +				root, &cleancache_failed_gets);
> +	debugfs_create_u64("puts", S_IRUGO, root, &cleancache_puts);
> +	debugfs_create_u64("invalidates", S_IRUGO,
> +				root, &cleancache_invalidates);
> +#endif

No exisiting userlands are affected by this change of flush->invalidates ?

Thanks,
-Kame

