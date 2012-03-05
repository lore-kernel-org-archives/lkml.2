Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2CENF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:05:59 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:21673 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab2CENF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:05:57 -0500
Message-ID: <4F54B9DE.60604@openvz.org>
Date: Mon, 05 Mar 2012 17:04:30 +0400
From: Kinsbursky Stanislav <skinsbursky@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "criu@openvz.org" <criu@openvz.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>
Subject: Re: [CRIU] [PATCH 0/5] IPC: checkpoint/restore in userspace enhancements
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
In-Reply-To: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.
Are you going to take this patch set?


09.02.2012 22:01, Stanislav Kinsbursky пишет:
> This patch set aimed to provide additional functionality for all IPC objects,
> which is required for migration these objects by user-space checkpoint/restore
> utils.
> The main problem here was impossibility to set up object id. This patch set
> solves the problem in two steps:
> 1) Makes it possible to create new object (shared memory, semaphores set or
> messages queue) with ID, equal to passed key.
> 2) Makes it possible to change existent object key.
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
> _______________________________________________
> CRIU mailing list
> CRIU@openvz.org
> https://openvz.org/mailman/listinfo/criu


-- 
Best regards,
Stanislav Kinsbursky

