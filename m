Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1K1PxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:53:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39865 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1K1PxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:53:23 -0500
Date: Mon, 28 Nov 2011 07:53:15 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] sysctl: Add the kernel.ns_last_pid control
Message-ID: <20111128155315.GA18864@google.com>
References: <4ED3A6F5.6070606@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED3A6F5.6070606@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 07:21:25PM +0400, Pavel Emelyanov wrote:
> +static int pid_ns_ctl_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table tmp = *table;
> +
> +	if (write && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/*
> +	 * Writing directly to ns' last_pid field is OK, since this field
> +	 * is volatile in a living namespace anyway and a code writing to
> +	 * it should synchronize its usage with external means.
> +	 */

I would still prefer using set_last_pid() but if you insist to update
last_pid directly, please note the direct update in the comment on top
of set_last_pid() too.

Other than that,

  Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
