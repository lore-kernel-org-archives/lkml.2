Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0EJIL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:11:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:51930 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0EJILx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:11:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="275188284"
Subject: Re: [Patch-next] Oops caused by ERST Table not supported.
From: Huang Ying <ying.huang@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: LKLM <linux-kernel@vger.kernel.org>, lenb <lenb@kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       ACPI <linux-acpi@vger.kernel.org>
In-Reply-To: <4BE7BE10.8080000@np.css.fujitsu.com>
References: <4BE7BE10.8080000@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 16:11:50 +0800
Message-ID: <1273479110.3344.56.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dongming,

On Mon, 2010-05-10 at 16:04 +0800, Jin Dongming wrote:
> On my server(x86_64) when the mcelog is executed, it will cause oops. And
> following information could be gotten.
> 
> Call Trace:
>   [<ffffffff812ceefd>] ? avc_has_perm_noaudit+0x4d/0x680
>   [<ffffffff812ceefd>] ? avc_has_perm_noaudit+0x4d/0x680
>   [<ffffffff8142492b>] erst_read_next+0x3b/0x100
>   [<ffffffff81028def>] apei_read_mce+0x2f/0x170
>   [<ffffffff811bfc5d>] ? check_object+0x36d/0x430
>   [<ffffffff811c059c>] ? init_object+0x9c/0xe0
>   [<ffffffff811c38ef>] ? __slab_alloc+0x7cf/0x8b0
>   [<ffffffff81025cba>] ? mce_read+0x4a/0x510
>   [<ffffffff811c49ab>] ? __kmalloc+0x2db/0x390
>   [<ffffffff81025cba>] ? mce_read+0x4a/0x510
>   [<ffffffff811bf81d>] ? check_bytes_and_report+0x3d/0x110
>   [<ffffffff816caf1e>] ? _cond_resched+0x3e/0x80
>   [<ffffffff8102613b>] mce_read+0x4cb/0x510
>   [<ffffffff812cb9f2>] ? security_file_permission+0x122/0x130
>   [<ffffffff811dff16>] ? rw_verify_area+0x196/0x210
>   [<ffffffff811e0e7b>] vfs_read+0x1bb/0x2f0
>   [<ffffffff811e172d>] sys_read+0x8d/0xe0
>   [<ffffffff81003c9b>] system_call_fastpath+0x16/0x1b
> 
> This is because of the ERST Table not supported on my server and it
> makes the variable "ctx" used by erst_read_nextis NULL. So I make
> the patch to solve this problem.
> 
> And I confirmed it on my server(x86_64).
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> ---
>  drivers/acpi/apei/erst.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> index 5fe5c0f..2ebc391 100644
> --- a/drivers/acpi/apei/erst.c
> +++ b/drivers/acpi/apei/erst.c
> @@ -698,6 +698,9 @@ ssize_t erst_read_next(struct cper_record_header *record, size_t buflen)
>  	unsigned long flags;
>  	u64 record_id;
>  
> +	if (erst_disable)
> +		return -ENODEV;
> +
>  	spin_lock_irqsave(&erst_lock, flags);
>  	rc = __erst_get_next_record_id(&record_id);
>  	if (rc) {

Thank you very much for your fixing.

Acked-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying


