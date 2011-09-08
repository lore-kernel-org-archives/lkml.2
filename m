Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1IHXef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:34:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab1IHXec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:34:32 -0400
Date: Thu, 8 Sep 2011 20:42:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v3] Simplify PTRACE_foo constants and PTRACE_SETOPTIONS
	code
Message-ID: <20110908184215.GA29439@redhat.com>
References: <1315495101.18043.1.camel@dhcp-25-63.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315495101.18043.1.camel@dhcp-25-63.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Denys Vlasenko wrote:
>
>  static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>  {
> ...
> +       if (data & ~(unsigned long)PTRACE_O_MASK) {
> +               child->ptrace &= ~PT_TRACE_MASK; /* historical bug */
> +               return -EINVAL;
> +       }

This is not right. You shouldn't simply return with -EINVAL, this change
adds another bug.  Note that the cuurrent code sets the new bits even if
it returns -EINVAL.

Oleg.

