Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1KIAWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:22:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab1KIAWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:22:23 -0500
Date: Tue, 8 Nov 2011 16:22:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Serge Hallyn <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        oleg@redhat.com, richard@nod.at, ebiederm@xmission.com,
        dhowells@redhat.com, eparis@redhat.com,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 1/6] user namespace: make signal.c respect user
 namespaces (v4)
Message-Id: <20111108162216.1ffb3e9a.akpm@linux-foundation.org>
In-Reply-To: <1320445482-8459-2-git-send-email-serge@hallyn.com>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
	<1320445482-8459-2-git-send-email-serge@hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Nov 2011 22:24:37 +0000
Serge Hallyn <serge@hallyn.com> wrote:

> +static inline void fixup_uid(struct siginfo *info, struct task_struct *t)
> +{
> +#ifdef CONFIG_USER_NS
> +	if (current_user_ns() == task_cred_xxx(t, user_ns))
> +#endif
> +		return;
> +
> +	if (SI_FROMKERNEL(info))
> +		return;
> +
> +	info->si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
> +					current_cred(), info->si_uid);
> +}

err, this function is a no-op if CONFIG_USER_NS=n.  If that was
intentional then why on earth do this in such a weird fashion?  If
unintentional then it makes me wonder how well tested all this was with
CONFIG_USER_NS=n?

I vaguely remember that I've forgotten how all this stuff works.  Some
additional review input would be nice (cough-oleg-cough).

