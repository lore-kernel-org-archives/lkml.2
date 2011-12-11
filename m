Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1LKS4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 13:56:05 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41604 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1LKS4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 13:56:03 -0500
Message-ID: <4EE4FCBB.9050600@gmail.com>
Date: Sun, 11 Dec 2011 13:55:55 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org
Subject: Re: [PATCH 1/3] nitpick: make simple functions inline
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-3-git-send-email-glommer@parallels.com>
In-Reply-To: <1323614738-7405-3-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static int notify_on_release(const struct cgroup *cgrp)
> +static inline int notify_on_release(const struct cgroup *cgrp)
>   {
>   	return test_bit(CGRP_NOTIFY_ON_RELEASE,&cgrp->flags);
>   }
> 
> -static int clone_children(const struct cgroup *cgrp)
> +static inline int clone_children(const struct cgroup *cgrp)
>   {
>   	return test_bit(CGRP_CLONE_CHILDREN,&cgrp->flags);
>   }

Can you please tell us which compiler failed automatic inlining?
I suspect gcc is enough sane and we don't need this patch.


