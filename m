Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab1IMUqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:46:19 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51156 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab1IMUqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:46:18 -0400
Message-ID: <4E6FC109.5090608@linux.vnet.ibm.com>
Date: Tue, 13 Sep 2011 15:46:01 -0500
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
Subject: Re: [PATCH V9 5/6] mm: cleancache: update to match akpm frontswap
 feedback
References: <20110913174106.GA11330@ca-server1.us.oracle.com>
In-Reply-To: <20110913174106.GA11330@ca-server1.us.oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
x-cbid: 11091320-6078-0000-0000-000000AFFA29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dan,

Same typecasting needed here:

mm/cleancache.c: In function ‘init_cleancache’:
mm/cleancache.c:214:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
mm/cleancache.c:216:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
mm/cleancache.c:218:5: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
include/linux/debugfs.h:68:16: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’

On 09/13/2011 12:41 PM, Dan Magenheimer wrote:
> +#ifdef CONFIG_DEBUG_FS
> +	struct dentry *root = debugfs_create_dir("cleancache", NULL);
> +	if (root == NULL)
> +		return -ENXIO;
> +	debugfs_create_size_t("succ_gets", S_IRUGO,
> +				root, &cleancache_succ_gets);
> +	debugfs_create_size_t("failed_gets", S_IRUGO,
> +				root, &cleancache_failed_gets);
> +	debugfs_create_size_t("puts", S_IRUGO,
> +				root, &cleancache_puts);
> +	debugfs_create_size_t("invalidates", S_IRUGO,
> +				root, &cleancache_invalidates);
> +#endif

