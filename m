Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0FWLnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 07:43:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53033 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab0FWLnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 07:43:49 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] security: Yama LSM
References: <20100623065236.GH5876@outflux.net>
Date: Wed, 23 Jun 2010 13:43:41 +0200
In-Reply-To: <20100623065236.GH5876@outflux.net> (Kees Cook's message of "Tue,
	22 Jun 2010 23:52:36 -0700")
Message-ID: <877hlqas9e.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:
> +
> +config SECURITY_YAMA_SYMLINKS
> +	bool "Yama: protect symlink following in sticky world-writable
> dirs"

IMHO it's bad style to have CONFIGs that just set defaults,
if that can be done at runtime too. Especially as in your case if it's 
a lot of settings. Is it that bad to have a init script and drop these 
CONFIGs? 

However the help texts are useful,  these should be in the sysctl
documentatin in Documentation instead.

> +	if (rc) {
> +		printk_ratelimited(KERN_INFO "ptrace of non-child"
> +			" pid %d was attempted by: %s (pid %d)\n",
> +			child->pid, get_task_comm(name, current),
> +			current->pid);

It's probably obscure and other kernel code has this too, but at some point
there were attacks to use terminal ESC sequences to attack root's
terminal when they dmesg. Couldn't that be done through "comm" here?

At least the other code who has this problem doesn't claim to enhance
security :)

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
