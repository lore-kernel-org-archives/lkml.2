Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab2JSQmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:42:39 -0400
Received: from mail.x86-64.org ([217.9.48.20]:37079 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758490Ab2JSQmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:42:37 -0400
Date: Fri, 19 Oct 2012 18:42:33 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tang Chen <tangchen@cn.fujitsu.com>, Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, miaox@cn.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 2/2] Do not change worker's running cpu in
 cmci_rediscover().
Message-ID: <20121019164233.GF11958@aftab.osrc.amd.com>
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
 <1350625528-1385-3-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350625528-1385-3-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 01:45:28PM +0800, Tang Chen wrote:
> cmci_rediscover() used set_cpus_allowed_ptr() to change the current process's
> running cpu, and migrate itself to the dest cpu. But worker processes are not
> allowed to be migrated. If current is a worker, the worker will be migrated to
> another cpu, but the corresponding  worker_pool is still on the original cpu.
> 
> In this case, the following BUG_ON in try_to_wake_up_local() will be triggered:
> BUG_ON(rq != this_rq());
> 
> This will cause the kernel panic.
> 
> This patch removes the set_cpus_allowed_ptr() call, and put the cmci rediscover
> jobs onto all the other cpus using system_wq. This could bring some delay for
> the jobs.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

I guess this is ok. Tony?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
