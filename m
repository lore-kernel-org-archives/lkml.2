Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1GHSmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:42:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab1GHSml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:42:41 -0400
Date: Fri, 8 Jul 2011 11:42:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: drosenberg@vsecurity.com
Cc: chris@zankel.net, security@kernel.org, linux-kernel@vger.kernel.org,
        "Oleg Nesterov" <oleg@redhat.com>
Subject: Re: [Security] [PATCH] xtensa: prevent arbitrary read in ptrace
Message-Id: <20110708114238.d70315b7.akpm@linux-foundation.org>
In-Reply-To: <1652523982-1310150159-cardhu_decombobulator_blackberry.rim.net-183695056-@b1.c19.bise6.blackberry>
References: <1652523982-1310150159-cardhu_decombobulator_blackberry.rim.net-183695056-@b1.c19.bise6.blackberry>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jul 2011 18:35:56 +0000
"Dan Rosenberg" <drosenberg@vsecurity.com> wrote:

> Sorry for the top post and any email mangling (mobile).
> 
> I only used EIO to mirror the existing behavior in ptrace_getxregs(). EFAULT seems better.

ptrace_getxregs() is busted ;)


int ptrace_getxregs(struct task_struct *child, void __user *uregs)
{
...
	if (!access_ok(VERIFY_WRITE, uregs, sizeof(elf_xtregs_t)))
		return -EIO;
...
	ret |= __copy_to_user(&xtregs->user,&ti->xtregs_user,
			      sizeof(xtregs->user));

	return ret ? -EFAULT : 0;
}

that makes no sense.

