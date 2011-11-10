Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1KJRaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:30:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34688 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1KJRaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:30:20 -0500
Date: Thu, 10 Nov 2011 09:30:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
Message-ID: <20111110173009.GH27258@google.com>
References: <4EBC0696.9030103@parallels.com>
 <4EBC06DB.3090202@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBC06DB.3090202@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel.

>  	for (i = ns->level; i >= 0; i--) {
> -		nr = alloc_pidmap(tmp);
> +		nr = 0;
> +		if (unlikely(want_pids != NULL)) {
> +			if (get_user(nr, want_pids)) {
> +				nr = -EFAULT;
> +				goto out_free;
> +			}
> +
> +			if (nr != 0) {
> +				want_pids++;
> +				nr = set_pidmap(tmp, nr);
> +			} else
> +				want_pids = NULL; /* optimize above */
> +		}
> +		if (nr == 0)
> +			nr = alloc_pidmap(tmp);

Hmmm... is it necessary to be able to replicate pids on all
namespaces?  Also, isn't it a bit weird to be able to request PIDs in
the namespaces which is beyond the task which requested cloning?

Thanks.

-- 
tejun
