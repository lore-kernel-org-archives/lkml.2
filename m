Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1CUQSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:18:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab1CUQSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:18:40 -0400
Date: Mon, 21 Mar 2011 17:09:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 3/8] job control: Fix ptracer wait(2) hang and explain
	notask_error clearing
Message-ID: <20110321160903.GA26520@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-4-git-send-email-tj@kernel.org> <20110321151941.GA20917@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321151941.GA20917@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Oleg Nesterov wrote:
>
> On 03/08, Tejun Heo wrote:
> >
> > +		if (likely(!ptrace) || (wo->wo_flags & WCONTINUED))
> > +			wo->notask_error = 0;
>
> I don't understand this part. Suppose that this task is not traced and
> its real parent does do_wait(WEXITED). We shouldn't return -ECHLD in
> this case (EXIT_ZOMBIE && delay_group_leader()).

Argh. please ingnore this part. I misread the code above.

> If the task is traced and debugger does do_wait(WEXITED) we should not
> return -ECHLD too.

Still true, or I missed something again...

Oleg.

