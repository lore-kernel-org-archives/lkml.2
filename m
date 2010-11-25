Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0KYAum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 19:50:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52356 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab0KYAul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 19:50:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: rcu_read_lock/unlock protect find_task_by_vpid call in migrate_pages
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20101125003339.GB31301@redhat.com>
References: <20101125003339.GB31301@redhat.com>
Message-Id: <20101125095012.F446.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Nov 2010 09:50:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4a57f13..2f0f55b 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1308,6 +1308,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
>  
>  	/* Find the mm_struct */
>  	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	task = pid ? find_task_by_vpid(pid) : current;
>  	if (!task) {
>  		read_unlock(&tasklist_lock);
> @@ -1315,6 +1316,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
>  		goto out;
>  	}
>  	mm = get_task_mm(task);
> +	rcu_read_unlock();
>  	read_unlock(&tasklist_lock);
>  
>  	err = -EINVAL;

Thanks reporting. but mmotm seems already has the same patch.



