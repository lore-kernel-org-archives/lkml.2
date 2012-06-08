Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023Ab2FHIkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:40:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37738 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670Ab2FHIkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:40:37 -0400
Date: Fri, 8 Jun 2012 10:40:33 +0200
From: Simon Baatz <gmbnomis@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephane Marchesin <marcheu@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Clark <rob.clark@linaro.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, linux-mm@kvack.org,
        linux-fsdevel@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shmem: replace_page must flush_dcache and others
Message-ID: <20120608084033.GA21818@schnuecks.de>
References: <alpine.LSU.2.00.1205311524160.4512@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205311524160.4512@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Thu, May 31, 2012 at 03:31:27PM -0700, Hugh Dickins wrote:
> * shmem_replace_page must flush_dcache_page after copy_highpage [akpm]

>  
> -	*pagep = newpage;
>  	page_cache_get(newpage);
>  	copy_highpage(newpage, oldpage);
> +	flush_dcache_page(newpage);
>  

Couldn't we use the lighter flush_kernel_dcache_page() here (like in
fs/exec.c copy_strings())?  If I got this correctly, the page is
copied via the kernel mapping and thus, only the kernel mapping needs
to be flushed.

- Simon
