Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2JVL1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:27:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46957 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2JVL1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:27:45 -0400
MIME-Version: 1.0
In-Reply-To: <1350665289-7288-1-git-send-email-andi@firstfloor.org>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 22 Oct 2012 13:27:23 +0200
X-Google-Sender-Auth: DPIVp0LjmLA-tvWKc9H3vQuEkZM
Message-ID: <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

> +#define MAP_HUGE_2MB    (21 << MAP_HUGE_SHIFT)
> +#define MAP_HUGE_1GB    (30 << MAP_HUGE_SHIFT)
> +#define SHM_HUGE_SHIFT  26
> +#define SHM_HUGE_MASK   0x3f
> +#define SHM_HUGE_2MB    (21 << SHM_HUGE_SHIFT)
> +#define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)

Maybe I am missing something obvious, but does this not conflict with
include/uapi/asm-generic/mman-common.h:

#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
# define MAP_UNINITIALIZED 0x4000000
...

0x4000000 == (1 << 26)
?

Thanks,

Michael

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
