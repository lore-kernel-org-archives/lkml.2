Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0LUSB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:01:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab0LUSB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:01:58 -0500
Date: Tue, 21 Dec 2010 18:54:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 16/16] ptrace: remove the extra wake_up_process() from
	ptrace_detach()
Message-ID: <20101221175439.GA19434@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-17-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-17-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -391,8 +391,6 @@ int ptrace_detach(struct task_struct *child, unsigned int data)
>  	if (child->ptrace) {
>  		child->exit_code = data;
>  		dead = __ptrace_detach(current, child);
> -		if (!child->exit_state)
> -			wake_up_process(child);

I can only repeat that I obviously like this change ;)

Now that Jan and Roland do not object, perhaps it can be sent as 2/X.
This is bugfix, after all (like the first patch).

Oleg.

