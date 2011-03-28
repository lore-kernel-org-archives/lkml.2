Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1C1Lzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 07:55:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47059 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1C1Lzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:55:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dan Carpenter <error27@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, serge@hallyn.com,
        David Howells <dhowells@redhat.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ipcns: use after free in free_ipc_ns()
References: <20110328085048.GI1885@bicker>
Date: Mon, 28 Mar 2011 04:55:31 -0700
In-Reply-To: <20110328085048.GI1885@bicker> (Dan Carpenter's message of "Mon,
	28 Mar 2011 11:50:48 +0300")
Message-ID: <m1vcz3zcgc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+BDaDWkOTKghFJ184SnXi/ojWycnJvh3E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> writes:

> We dereference "ns" after it has been freed.  This was introduced in
> b515498f5bb5 "userns: add a user namespace owner of ipc ns".

I think Andrew has already merged this fix.


>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/ipc/namespace.c b/ipc/namespace.c
> index 3c3e522..8054c8e 100644
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -104,7 +104,6 @@ static void free_ipc_ns(struct ipc_namespace *ns)
>  	sem_exit_ns(ns);
>  	msg_exit_ns(ns);
>  	shm_exit_ns(ns);
> -	kfree(ns);
>  	atomic_dec(&nr_ipc_ns);
>  
>  	/*
> @@ -113,6 +112,7 @@ static void free_ipc_ns(struct ipc_namespace *ns)
>  	 */
>  	ipcns_notify(IPCNS_REMOVED);
>  	put_user_ns(ns->user_ns);
> +	kfree(ns);
>  }
>  
>  /*
