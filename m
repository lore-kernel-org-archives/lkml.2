Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0KWHRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:17:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37370 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab0KWHRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:17:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Subject: Re: [PATCH][V2] nommu: yield CPU while disposing VM
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, stable@kernel.org,
        linux-kernel@vger.kernel.org, gerg@snapgear.com,
        akpm@linux-foundation.org
In-Reply-To: <1289912805-4143-1-git-send-email-steve@digidescorp.com>
References: <1289912805-4143-1-git-send-email-steve@digidescorp.com>
Message-Id: <20101122100830.E22A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:16:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Depending on processor speed, page size, and the amount of memory a process
> is allowed to amass, cleanup of a large VM may freeze the system for many
> seconds. This can result in a watchdog timeout.
> 
> Make sure other tasks receive some service when cleaning up large VMs.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/mm/nommu.c b/mm/nommu.c
> --- a/mm/nommu.c	2010-11-15 07:53:45.000000000 -0600
> +++ b/mm/nommu.c	2010-11-15 07:57:13.000000000 -0600
> @@ -1668,6 +1668,7 @@ void exit_mmap(struct mm_struct *mm)
>  		mm->mmap = vma->vm_next;
>  		delete_vma_from_mm(vma);
>  		delete_vma(mm, vma);
> +		cond_resched();
>  	}
>  
>  	kleave("");
> 

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


