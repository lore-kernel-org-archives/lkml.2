Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1IVGCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:02:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3038 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1IVGCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:02:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=kiC/A5y8GXXSagur2Y+gq801mtCEmaqFJlfepPKRx9xc4b1awt7qV/DNrmcqLrppw
	qVY/U35zJLQziSrfnPlsQ==
MIME-Version: 1.0
In-Reply-To: <1316393805-3005-7-git-send-email-glommer@parallels.com>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com> <1316393805-3005-7-git-send-email-glommer@parallels.com>
From: Greg Thelen <gthelen@google.com>
Date: Wed, 21 Sep 2011 23:01:46 -0700
Message-ID: <CAHH2K0Yuji2_2pMdzEaMvRx0KE7OOaoEGT+OK4gJgTcOPKuT9g@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] tcp buffer limitation: per-cgroup limit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        kirill@shutemov.name
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 5:56 PM, Glauber Costa <glommer@parallels.com> wrote:
> +static inline bool mem_cgroup_is_root(struct mem_cgroup *mem)
> +{
> +       return (mem == root_mem_cgroup);
> +}
> +

Why are you adding a copy of mem_cgroup_is_root().  I see one already
in v3.0.  Was it deleted in a previous patch?

> +static int tcp_write_maxmem(struct cgroup *cgrp, struct cftype *cft, u64 val)
> +{
> +       struct mem_cgroup *sg = mem_cgroup_from_cont(cgrp);
> +       struct mem_cgroup *parent = parent_mem_cgroup(sg);
> +       struct net *net = current->nsproxy->net_ns;
> +       int i;
> +
> +       if (!cgroup_lock_live_group(cgrp))
> +               return -ENODEV;

Why is cgroup_lock_live_cgroup() needed here?  Does it protect updates
to sg->tcp_prot_mem[*]?

> +static u64 tcp_read_maxmem(struct cgroup *cgrp, struct cftype *cft)
> +{
> +       struct mem_cgroup *sg = mem_cgroup_from_cont(cgrp);
> +       u64 ret;
> +
> +       if (!cgroup_lock_live_group(cgrp))
> +               return -ENODEV;

Why is cgroup_lock_live_cgroup() needed here?  Does it protect updates
to sg->tcp_max_memory?
