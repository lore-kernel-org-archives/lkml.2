Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802Ab2EWUvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:51:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56411 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761Ab2EWUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:51:54 -0400
Message-ID: <4FBD4DDF.5080905@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 15:51:43 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH v2 1/3] zsmalloc: support zsmalloc to ARM, MIPS, SUPERH
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1337133919-4182-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052320-5518-0000-0000-000004A1111D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 09:05 PM, Minchan Kim wrote:

> zsmalloc uses set_pte and __flush_tlb_one for performance but
> many architecture don't support it. so this patch removes
> set_pte and __flush_tlb_one which are x86 dependency.
> Instead of it, use local_flush_tlb_kernel_range which are available
> by more architectures. It would be better than supporting only x86
> and last patch in series will enable again with supporting
> local_flush_tlb_kernel_range in x86.
> 
> About local_flush_tlb_kernel_range,
> If architecture is very smart, it could flush only tlb entries related to vaddr.
> If architecture is smart, it could flush only tlb entries related to a CPU.
> If architecture is _NOT_ smart, it could flush all entries of all CPUs.
> So, it would be best to support both portability and performance.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Chen Liqin <liqin.chen@sunplusct.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>


For the zsmalloc changes:

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Thanks,
Seth

