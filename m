Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1HWPz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:55:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab1HWPzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:55:21 -0400
Date: Tue, 23 Aug 2011 17:52:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110823155221.GB25808@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Not a comment, but the question. Probably falls into the "read the
whole series" category too.

On 08/19, Tejun Heo wrote:
>
> There's no point in freezing an exiting task.

This is not clear to me. Probably this is fine, I do not know what
the callers of freeze_processes() actually expect.

> @@ -915,6 +913,12 @@ NORET_TYPE void do_exit(long code)
>
>  	ptrace_event(PTRACE_EVENT_EXIT, code);
>
> +	/*
> +	 * With ptrace notification done, there's no point in freezing from
> +	 * here on.  Disallow freezing.
> +	 */
> +	current->flags |= PF_NOFREEZE;

OK, but what PF_NOFREEZE actually means?

Apart from "dont try to freeze" it means "no need to freeze", yes?

IOW, try_to_freeze_tasks() can succeed even if we have a lot of
exitinig task which can make some activity, say, disk i/o. Is this
correct?

Once again, I do not understand the problem-space at all, jus I am
curious.

Thanks,

Oleg.

