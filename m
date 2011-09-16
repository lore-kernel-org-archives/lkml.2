Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1IPPM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 11:12:27 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58732 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1IPPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 11:12:26 -0400
Message-ID: <4E73674B.6090901@linux.vnet.ibm.com>
Date: Fri, 16 Sep 2011 10:12:11 -0500
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
Subject: Re: [PATCH V10 3/6] mm: frontswap: core frontswap functionality
References: <20110915213406.GA26369@ca-server1.us.oracle.com>
In-Reply-To: <20110915213406.GA26369@ca-server1.us.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 04:34 PM, Dan Magenheimer wrote:
> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Subject: [PATCH V10 3/6] mm: frontswap: core frontswap functionality
> 
> (Note to earlier reviewers:  This patchset has been reorganized due to
> feedback from Kame Hiroyuki and Andrew Morton. This patch contains part
> of patch 3of4 from the previous series.)
> 
> This third patch of six in the frontswap series provides the core
> frontswap code that interfaces between the hooks in the swap subsystem
> and a frontswap backend via frontswap_ops.
> 
> [v10: sjenning@linux.vnet.ibm.com: fix debugfs calls on 32-bit]
...
> +#ifdef CONFIG_DEBUG_FS
> +	struct dentry *root = debugfs_create_dir("frontswap", NULL);
> +	if (root == NULL)
> +		return -ENXIO;
> +	debugfs_create_u64("gets", S_IRUGO, root, &frontswap_gets);
> +	debugfs_create_u64("succ_puts", S_IRUGO, root, &frontswap_succ_puts);
> +	debugfs_create_u64("puts", S_IRUGO, root, &frontswap_failed_puts);

Sorry I didn't see this one before :-/  This should be "failed_puts",
not "puts".

Other than that, it compiles cleanly here and runs without issue when
applied on 3.1-rc4 + fix for cleancache crash.

Thanks
--
Seth

