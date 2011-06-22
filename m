Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1FVQDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:03:44 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:60224 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932301Ab1FVQDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:03:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Wpgewvpx49K2bePPtVLeNDatVEME1D+/7Bir0aE8V9kVWYx0ZjsFsdpZ88dJyvNHaM0ZnrVhyo7zhH6O+I3giv1I1FUEdndAh3SCMCilfCyd7c/lZgE9f3h0rVYL0Ca3;
Date: Wed, 22 Jun 2011 09:03:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC] ipc: introduce shm_rmid_forced sysctl
Message-Id: <20110622090331.fd6a3cc7.rdunlap@xenotime.net>
In-Reply-To: <20110622152514.GA9521@albatros>
References: <20110622152514.GA9521@albatros>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 19:25:14 +0400 Vasiliy Kulikov wrote:

> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
> 
>  Documentation/sysctl/kernel.txt |   22 ++++++++++
>  include/linux/ipc_namespace.h   |    3 +
>  include/linux/shm.h             |    5 ++
>  ipc/ipc_sysctl.c                |   33 +++++++++++++++
>  ipc/shm.c                       |   87 +++++++++++++++++++++++++++++++++++++--
>  kernel/exit.c                   |    1 +
>  6 files changed, 147 insertions(+), 4 deletions(-)
> 
> ---
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 5e7cb39..7a0ecfd 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -62,6 +62,7 @@ show up in /proc/sys/kernel:
>  - shmall
>  - shmmax                      [ sysv ipc ]
>  - shmmni
> +- shm_rmid_forced
>  - stop-a                      [ SPARC only ]
>  - sysrq                       ==> Documentation/sysrq.txt
>  - tainted
> @@ -475,6 +476,27 @@ kernel.  This value defaults to SHMMAX.
>  
>  ==============================================================
>  
> +shm_rmid_forced:
> +
> +Linux lets you set resource limits, including on how much memory one

                                       including how much memory one

> +process can consume, via setrlimit(2).  Unfortunately, shared memory
> +segments are allowed to exist without association with any process, and
> +thus might not be counted against any resource limits.  If enabled,
> +shared memory segments are automatically destroyed when their attach
> +count becomes zero after a detach or a process termination.  It will
> +also destroy segments that were created, but never attached to, on exit
> +from the process.  The only use left for IPC_RMID is to immediately
> +destroy an unattached segment.  Of course, this breaks the way things are
> +defined, so some applications might stop working.  Note that this
> +feature will do you no good unless you also configure your resource
> +limits (in particular, RLIMIT_AS and RLIMIT_NPROC).  Most systems don't
> +need this.
> +
> +Note that if you change this from 0 to 1, already created segments
> +without users and with a dead originative process will be destroyed.

                                 originating (?)

> +
> +==============================================================
> +
>  softlockup_thresh:
>  
>  This value can be used to lower the softlockup tolerance threshold.  The



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
