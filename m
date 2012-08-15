Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2HOIIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:08:12 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:39343 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2HOIID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:08:03 -0400
Date: Wed, 15 Aug 2012 10:07:53 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/2] s390: Always use "long" for ssize_t to match size_t
Message-ID: <20120815080752.GC3622@osiris.de.ibm.com>
References: <1344765694-7465-1-git-send-email-geert@linux-m68k.org>
 <1344765694-7465-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344765694-7465-2-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12081508-0542-0000-0000-000002BD138B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 12:01:34PM +0200, Geert Uytterhoeven wrote:
> On s390x-linux-gcc, __SIZE_TYPE__ expands to "long unsigned int" for both
> 32-bit s390 and 64-bit s390x, as
> gcc-4.6.3-nolibc/s390x-linux/lib/gcc/s390x-linux/4.6.3/plugin/include/config/s390/linux.h
> has
> 
>     #define SIZE_TYPE (TARGET_64BIT ? "long unsigned int" : "long unsigned int")
> 
> To match this, __kernel_size_t is always set to "long unsigned int".
> 
> But while __kernel_ssize_t is "long" on 64-bit s390x, it is "int" on 32-bit
> s390, causing compiler warnings like:
> 
>     fs/quota/quota_tree.c:372:4: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]
> 
> To fix this, __kernel_ssize_t should be "long", irrespective of word size.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied. Thanks Geert!

