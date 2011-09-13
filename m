Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab1IMUk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:40:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36040 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab1IMUk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:40:56 -0400
Message-ID: <4E6FBFC4.1080901@linux.vnet.ibm.com>
Date: Tue, 13 Sep 2011 15:40:36 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, kamezawa.hiroyu@jp.fujitsu.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V9 3/6] mm: frontswap: core frontswap functionality
References: <20110913174026.GA11298@ca-server1.us.oracle.com>
In-Reply-To: <20110913174026.GA11298@ca-server1.us.oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dan,

I get the following compile warnings:

mm/frontswap.c: In function ‘init_frontswap’:
mm/frontswap.c:264:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
mm/frontswap.c:266:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
mm/frontswap.c:268:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
mm/frontswap.c:270:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’

size_t is platform dependent but is generally "unsigned int"
for 32-bit and "unsigned long" for 64-bit.

I think just typecasting these to size_t * would fix it.

On 09/13/2011 12:40 PM, Dan Magenheimer wrote:
> +#ifdef CONFIG_DEBUG_FS
> +	struct dentry *root = debugfs_create_dir("frontswap", NULL);
> +	if (root == NULL)
> +		return -ENXIO;
> +	debugfs_create_size_t("gets", S_IRUGO,
> +				root, &frontswap_gets);
> +	debugfs_create_size_t("succ_puts", S_IRUGO,
> +				root, &frontswap_succ_puts);
> +	debugfs_create_size_t("puts", S_IRUGO,
> +				root, &frontswap_failed_puts);
> +	debugfs_create_size_t("invalidates", S_IRUGO,
> +				root, &frontswap_invalidates);
> +#endif
