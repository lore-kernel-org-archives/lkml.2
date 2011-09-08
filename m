Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab1IHAGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:06:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37051 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab1IHAGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:06:23 -0400
Date: Thu, 8 Sep 2011 09:06:14 +0900
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplify PTRACE_foo constants and PTRACE_SETOPTIONS code
Message-ID: <20110908000614.GA3987@mtj.dyndns.org>
References: <201109072336.37300.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109072336.37300.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mostly looks good to me.  Just a small nit.

On Wed, Sep 07, 2011 at 11:36:37PM +0200, Denys Vlasenko wrote:
>  static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>  {
> +	unsigned flags;
>  
> +	if (data & ~(long)PTRACE_O_MASK) {

Can we use (unsigned long) here?  Signed extensions have a nasty way
of sneaking up on you.

> +		child->ptrace &= ~PT_TRACE_MASK; /* historical bug */

And it would be great if it explains what the historical bug was and
what the intended behavior is.

Other than that,

 Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
