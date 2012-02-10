Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812Ab2BJS3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:29:19 -0500
Received: from nm3-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.136]:37633
	"HELO nm3-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759746Ab2BJS3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:29:17 -0500
X-Yahoo-Newman-Id: 895203.41456.bm@smtp106.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: U5lyHCoVM1n8Yxt1Cax_gQRX_sDuETLgqCQJ51U6rT5YVYg
 u9.RGCgEuOYPUpu87ylEd._pu48iQA0eBAi0jSJk5N5guZJqmH8ioEnOIEgU
 2ZTavAd5.OnrRzvt.1TC1l9ZYTV05_X4UNJH4pzoL_5RFn25YvasxSmaTIS2
 gfJA4ExWuBPmOyivcUE_drez0ObUwJKhxfVh4BN2RazT.8sIBcaeXufzoQV.
 TuPXv2pzg26fjYnrRMnQZUcUn6OVY47.U9cKP5GcZCPwZ_Ef.hnI_70TJrZF
 4zh9vf4dR8GxJzoyRBHKM64hxacD03nrFB7eEyYm1EN8BB_Cek6er_m02aTA
 LLUOekUZNUh8zkbLya3plUPJ8qkeDVzTfyT4lAsXA4OeVsV49tkME9jWGHGH
 HckRtYDeoiFJ0cVhes3ZGoeATMGjUFmjGMEboS2_Vg836V9c-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F356206.1080509@schaufler-ca.com>
Date: Fri, 10 Feb 2012 10:29:26 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: akpm@linux-foundation.org, jmorris@namei.org, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-security-module@vger.kernel.org,
        viro@zeniv.linux.org.uk, eparis@parisplace.org, sds@tycho.nsa.gov
Subject: Re: [PATCH 0/5] IPC: checkpoint/restore in userspace enhancements
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
In-Reply-To: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/2012 10:01 AM, Stanislav Kinsbursky wrote:
> This patch set aimed to provide additional functionality for all IPC objects,
> which is required for migration these objects by user-space checkpoint/restore
> utils.
> The main problem here was impossibility to set up object id. This patch set
> solves the problem in two steps:
> 1) Makes it possible to create new object (shared memory, semaphores set or
> messages queue) with ID, equal to passed key.
> 2) Makes it possible to change existent object key.

Is there any chance you might include the LSM data as well?

>
> The following series consists of:
>
> ---
>
> Stanislav Kinsbursky (5):
>        ipc: "use key as id" functionality for resource get system call introduced
>        ipc: segment key change helper introduced
>        ipc: add new SHM_SET command for sys_shmctl() call
>        ipc: add new MSG_SET command for sys_msgctl() call
>        ipc: add new SEM_SET command for sys_semctl() call
>
>
>   include/linux/ipc.h        |    1 +
>   include/linux/msg.h        |    1 +
>   include/linux/sem.h        |    1 +
>   include/linux/shm.h        |    1 +
>   ipc/compat.c               |    9 +++++++
>   ipc/msg.c                  |   14 +++++++++-
>   ipc/sem.c                  |   11 +++++++-
>   ipc/shm.c                  |   14 +++++++++-
>   ipc/util.c                 |   59 +++++++++++++++++++++++++++++++++++++++++---
>   ipc/util.h                 |    3 ++
>   security/selinux/hooks.c   |    3 ++
>   security/smack/smack_lsm.c |    3 ++
>   12 files changed, 110 insertions(+), 10 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

