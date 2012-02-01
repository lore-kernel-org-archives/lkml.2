Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2BAGp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:45:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63139 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2BAGp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:45:56 -0500
Message-ID: <4F28DF9B.40702@gmail.com>
Date: Wed, 01 Feb 2012 14:45:47 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
References: <20120201063420.GA10204@darkstar.nay.redhat.com>
In-Reply-To: <20120201063420.GA10204@darkstar.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 02:34 PM, Dave Young wrote:
> tools/ is the better place for vm tools which are used by many people.
> Moving them to tools also make them open to more users instead of hide in
> Documentation folder.

Well, hugepage-mmap, hugepage-shm, and map_hugetlb are examples, not 
really tools. So, only page-types is probably a tool, but I leave this 
to Fengguang to decide.

>
> Also fixed several coding style problem.

Make it another patch for people to review. :)

[...]
> diff --git a/tools/vm/Makefile b/tools/vm/Makefile
> new file mode 100644
> index 0000000..b4f9fdd
> --- /dev/null
> +++ b/tools/vm/Makefile
> @@ -0,0 +1,11 @@
> +# Makefile for vm tools
> +
> +CC = $(CROSS_COMPILE)gcc
> +CFLAGS = -Wall -Wextra
> +
> +all: page-types hugepage-mmap hugepage-shm map_hugetlb
> +%: %.c
> +	$(CC) $(CFLAGS) -o $@ $^
> +
> +clean:
> +	$(RM) page-types hugepage-mmap hugepage-shm map_hugetlb

Is $(RM) defined?
