Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab2JOTAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:00:36 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:20776 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751025Ab2JOTAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:00:35 -0400
Message-ID: <1350327628.2819.21.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v6 04/10] ipc: add new SHM_SET command for sys_shmctl()
 call
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: <akpm@linux-foundation.org>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <dhowells@redhat.com>,
        <manfred@colorfullife.com>, <hughd@google.com>, <jmorris@namei.org>,
        <mtk.manpages@gmail.com>, <kosaki.motohiro@jp.fujitsu.com>,
        <paulmck@linux.vnet.ibm.com>, <sds@tycho.nsa.gov>, <devel@openvz.org>,
        <a.p.zijlstra@chello.nl>, <cmetcalf@tilera.com>,
        <linux-driver@qlogic.com>, <ron.mercer@qlogic.com>,
        <viro@zeniv.linux.org.uk>, <eparis@parisplace.org>,
        <tglx@linutronix.de>, <jitendra.kalsaria@qlogic.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <ebiederm@xmission.com>,
        <casey@schaufler-ca.com>
Date: Mon, 15 Oct 2012 20:00:28 +0100
In-Reply-To: <20121015155956.28348.36765.stgit@localhost.localdomain>
References: <20121015155800.28348.23561.stgit@localhost.localdomain>
	 <20121015155956.28348.36765.stgit@localhost.localdomain>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 19:59 +0400, Stanislav Kinsbursky wrote:
> New SHM_SET command will be interpreted exactly as IPC_SET, but also will
> update key, cuid and cgid values. IOW, it allows to change existent key value.
> The fact, that key is not used is checked before update. Otherwise -EEXIST is
> returned.
[...]
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
[...]
> @@ -759,6 +763,10 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
>  	case IPC_RMID:
>  		do_shm_rmid(ns, ipcp);
>  		goto out_up;
> +	case SHM_SET:
> +		err = ipc_update_key(&shm_ids(ns), &shmid64.shm_perm, ipcp);
> +		if (err)
> +			break;
[...]

Please add /* fall through */ here, and in the similar cases in patches
5 and 7, to make clear that it's deliberate.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

