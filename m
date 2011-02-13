Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1BMQJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 11:09:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55690 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1BMQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 11:09:25 -0500
Date: Sun, 13 Feb 2011 16:09:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: Re: [PATCHv2 11/11] unicore32 core architecture: signals handling
Message-ID: <20110213160921.GA3239@ZenIV.linux.org.uk>
References: <02f701cbcb49$1defd860$59cf8920$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02f701cbcb49$1defd860$59cf8920$@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 02:42:00PM +0800, Guan Xuetao wrote:
> This patch implements signals.

> +static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
> +{
> +	sigset_t set;
> +	int err;
> +
> +	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
> +	if (err == 0) {
> +		sigdelsetmask(&set, ~_BLOCKABLE);
> +		spin_lock_irq(&current->sighand->siglock);
> +		current->blocked = set;
> +		recalc_sigpending();
> +		spin_unlock_irq(&current->sighand->siglock);
> +	}
> +
> +	err |= __get_user(regs->UCreg_00, &sf->uc.uc_mcontext.regs.UCreg_00);
> +	err |= __get_user(regs->UCreg_01, &sf->uc.uc_mcontext.regs.UCreg_01);
> +	err |= __get_user(regs->UCreg_02, &sf->uc.uc_mcontext.regs.UCreg_02);
> +	err |= __get_user(regs->UCreg_03, &sf->uc.uc_mcontext.regs.UCreg_03);
> +	err |= __get_user(regs->UCreg_04, &sf->uc.uc_mcontext.regs.UCreg_04);
> +	err |= __get_user(regs->UCreg_05, &sf->uc.uc_mcontext.regs.UCreg_05);
> +	err |= __get_user(regs->UCreg_06, &sf->uc.uc_mcontext.regs.UCreg_06);
> +	err |= __get_user(regs->UCreg_07, &sf->uc.uc_mcontext.regs.UCreg_07);
> +	err |= __get_user(regs->UCreg_08, &sf->uc.uc_mcontext.regs.UCreg_08);
> +	err |= __get_user(regs->UCreg_09, &sf->uc.uc_mcontext.regs.UCreg_09);
> +	err |= __get_user(regs->UCreg_10, &sf->uc.uc_mcontext.regs.UCreg_10);
> +	err |= __get_user(regs->UCreg_11, &sf->uc.uc_mcontext.regs.UCreg_11);
> +	err |= __get_user(regs->UCreg_12, &sf->uc.uc_mcontext.regs.UCreg_12);
> +	err |= __get_user(regs->UCreg_13, &sf->uc.uc_mcontext.regs.UCreg_13);
> +	err |= __get_user(regs->UCreg_14, &sf->uc.uc_mcontext.regs.UCreg_14);
> +	err |= __get_user(regs->UCreg_15, &sf->uc.uc_mcontext.regs.UCreg_15);
> +	err |= __get_user(regs->UCreg_16, &sf->uc.uc_mcontext.regs.UCreg_16);
> +	err |= __get_user(regs->UCreg_17, &sf->uc.uc_mcontext.regs.UCreg_17);
> +	err |= __get_user(regs->UCreg_18, &sf->uc.uc_mcontext.regs.UCreg_18);
> +	err |= __get_user(regs->UCreg_19, &sf->uc.uc_mcontext.regs.UCreg_19);
> +	err |= __get_user(regs->UCreg_20, &sf->uc.uc_mcontext.regs.UCreg_20);
> +	err |= __get_user(regs->UCreg_21, &sf->uc.uc_mcontext.regs.UCreg_21);
> +	err |= __get_user(regs->UCreg_22, &sf->uc.uc_mcontext.regs.UCreg_22);
> +	err |= __get_user(regs->UCreg_23, &sf->uc.uc_mcontext.regs.UCreg_23);
> +	err |= __get_user(regs->UCreg_24, &sf->uc.uc_mcontext.regs.UCreg_24);
> +	err |= __get_user(regs->UCreg_25, &sf->uc.uc_mcontext.regs.UCreg_25);
> +	err |= __get_user(regs->UCreg_26, &sf->uc.uc_mcontext.regs.UCreg_26);
> +	err |= __get_user(regs->UCreg_fp, &sf->uc.uc_mcontext.regs.UCreg_fp);
> +	err |= __get_user(regs->UCreg_ip, &sf->uc.uc_mcontext.regs.UCreg_ip);
> +	err |= __get_user(regs->UCreg_sp, &sf->uc.uc_mcontext.regs.UCreg_sp);
> +	err |= __get_user(regs->UCreg_lr, &sf->uc.uc_mcontext.regs.UCreg_lr);
> +	err |= __get_user(regs->UCreg_pc, &sf->uc.uc_mcontext.regs.UCreg_pc);
> +	err |= __get_user(regs->UCreg_asr, &sf->uc.uc_mcontext.regs.UCreg_asr);
> +
> +	err |= !valid_user_regs(regs);

a) where is valid_user_regs() defined?

b) assuming it's not always returning true (and it'd better, or you'll be able
to do interesting things with asr here), can it fail on frame setup path?
And what do you do if it *does* fail there and resulting SIGSEGV is caught and
handled?
