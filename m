Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248Ab1GMKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:25:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36844 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965169Ab1GMKZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:25:25 -0400
Date: Wed, 13 Jul 2011 12:25:20 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace_init_task: initialize child->jobctl explicitly
Message-ID: <20110713102520.GI2872@htj.dyndns.org>
References: <20110708171320.GA26943@redhat.com>
 <20110708171339.GB26943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708171339.GB26943@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 07:13:39PM +0200, Oleg Nesterov wrote:
> new_child->jobctl is not initialized during the fork, it is copied
> from parent->jobctl. Currently this is harmless, the forking task
> is running and copy_process() can't succeed if signal_pending() is
> true, so only JOBCTL_STOP_DEQUEUED can be copied. Still this is a
> bit fragile, it would be more clean to set ->jobctl = 0 explicitly.
> 
> Also, check ->ptrace != 0 instead of PT_PTRACED, move the
> CONFIG_HAVE_HW_BREAKPOINT code up.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
