Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1BNKEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:04:32 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:44848 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1BNKE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:04:29 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Al Viro'" <viro@ZenIV.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
References: <02f701cbcb49$1defd860$59cf8920$@mprc.pku.edu.cn> <20110213160921.GA3239@ZenIV.linux.org.uk>
In-Reply-To: <20110213160921.GA3239@ZenIV.linux.org.uk>
Subject: RE: [PATCHv2 11/11] unicore32 core architecture: signals handling
Date: Mon, 14 Feb 2011 18:04:09 +0800
Message-ID: <005c01cbcc2e$868e3660$93aaa320$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQI6kUZq/d4qbb3+lJ3N0RSRMowAFwKARl46kw8y5HA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
> Sent: Monday, February 14, 2011 12:09 AM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; Arnd Bergmann; 'Greg KH'
> Subject: Re: [PATCHv2 11/11] unicore32 core architecture: signals handling
> 
> On Sun, Feb 13, 2011 at 02:42:00PM +0800, Guan Xuetao wrote:
> > This patch implements signals.
> 
> > +static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
> > +{
> > +	sigset_t set;
> > +	int err;
> > +
> > +	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
> > +	if (err == 0) {
> > +		sigdelsetmask(&set, ~_BLOCKABLE);
> > +		spin_lock_irq(&current->sighand->siglock);
> > +		current->blocked = set;
> > +		recalc_sigpending();
> > +		spin_unlock_irq(&current->sighand->siglock);
> > +	}
> > +
> > +	err |= __get_user(regs->UCreg_00, &sf->uc.uc_mcontext.regs.UCreg_00);
> > +	err |= __get_user(regs->UCreg_01, &sf->uc.uc_mcontext.regs.UCreg_01);
> > +	err |= __get_user(regs->UCreg_02, &sf->uc.uc_mcontext.regs.UCreg_02);
> > +	err |= __get_user(regs->UCreg_03, &sf->uc.uc_mcontext.regs.UCreg_03);
> > +	err |= __get_user(regs->UCreg_04, &sf->uc.uc_mcontext.regs.UCreg_04);
> > +	err |= __get_user(regs->UCreg_05, &sf->uc.uc_mcontext.regs.UCreg_05);
> > +	err |= __get_user(regs->UCreg_06, &sf->uc.uc_mcontext.regs.UCreg_06);
> > +	err |= __get_user(regs->UCreg_07, &sf->uc.uc_mcontext.regs.UCreg_07);
> > +	err |= __get_user(regs->UCreg_08, &sf->uc.uc_mcontext.regs.UCreg_08);
> > +	err |= __get_user(regs->UCreg_09, &sf->uc.uc_mcontext.regs.UCreg_09);
> > +	err |= __get_user(regs->UCreg_10, &sf->uc.uc_mcontext.regs.UCreg_10);
> > +	err |= __get_user(regs->UCreg_11, &sf->uc.uc_mcontext.regs.UCreg_11);
> > +	err |= __get_user(regs->UCreg_12, &sf->uc.uc_mcontext.regs.UCreg_12);
> > +	err |= __get_user(regs->UCreg_13, &sf->uc.uc_mcontext.regs.UCreg_13);
> > +	err |= __get_user(regs->UCreg_14, &sf->uc.uc_mcontext.regs.UCreg_14);
> > +	err |= __get_user(regs->UCreg_15, &sf->uc.uc_mcontext.regs.UCreg_15);
> > +	err |= __get_user(regs->UCreg_16, &sf->uc.uc_mcontext.regs.UCreg_16);
> > +	err |= __get_user(regs->UCreg_17, &sf->uc.uc_mcontext.regs.UCreg_17);
> > +	err |= __get_user(regs->UCreg_18, &sf->uc.uc_mcontext.regs.UCreg_18);
> > +	err |= __get_user(regs->UCreg_19, &sf->uc.uc_mcontext.regs.UCreg_19);
> > +	err |= __get_user(regs->UCreg_20, &sf->uc.uc_mcontext.regs.UCreg_20);
> > +	err |= __get_user(regs->UCreg_21, &sf->uc.uc_mcontext.regs.UCreg_21);
> > +	err |= __get_user(regs->UCreg_22, &sf->uc.uc_mcontext.regs.UCreg_22);
> > +	err |= __get_user(regs->UCreg_23, &sf->uc.uc_mcontext.regs.UCreg_23);
> > +	err |= __get_user(regs->UCreg_24, &sf->uc.uc_mcontext.regs.UCreg_24);
> > +	err |= __get_user(regs->UCreg_25, &sf->uc.uc_mcontext.regs.UCreg_25);
> > +	err |= __get_user(regs->UCreg_26, &sf->uc.uc_mcontext.regs.UCreg_26);
> > +	err |= __get_user(regs->UCreg_fp, &sf->uc.uc_mcontext.regs.UCreg_fp);
> > +	err |= __get_user(regs->UCreg_ip, &sf->uc.uc_mcontext.regs.UCreg_ip);
> > +	err |= __get_user(regs->UCreg_sp, &sf->uc.uc_mcontext.regs.UCreg_sp);
> > +	err |= __get_user(regs->UCreg_lr, &sf->uc.uc_mcontext.regs.UCreg_lr);
> > +	err |= __get_user(regs->UCreg_pc, &sf->uc.uc_mcontext.regs.UCreg_pc);
> > +	err |= __get_user(regs->UCreg_asr, &sf->uc.uc_mcontext.regs.UCreg_asr);
> > +
> > +	err |= !valid_user_regs(regs);
> 
> a) where is valid_user_regs() defined?
This function is defined in arch/unicore32/include/asm/ptrace.h
as following:
/* Are the current registers suitable for user mode?
 * (used to maintain security in signal handlers)
 */
static inline int valid_user_regs(struct pt_regs *regs)
{
	unsigned long mode = regs->UCreg_asr & MODE_MASK;

	/*
	 * Always clear the R (REAL) bits
	 */
	regs->UCreg_asr &= ~(PSR_R_BIT);

	if ((regs->UCreg_asr & PSR_I_BIT) == 0) {
		if (mode == USER_MODE)
			return 1;
	}

	/*
	 * Force ASR to something logical...
	 */
	regs->UCreg_asr &= PSR_f | USER_MODE;

	return 0;
}
The function only assures that processor mode is in user mode and interrupt enabled
when syscall rt_sigreturn being executed.
Perhaps the function is no used in here!?

> 
> b) assuming it's not always returning true (and it'd better, or you'll be able
> to do interesting things with asr here), can it fail on frame setup path?
> And what do you do if it *does* fail there and resulting SIGSEGV is caught and
> handled?
In sys_rt_sigreturn, the return value of restore_sigframe() is tested,  and if failed,
SIGSEGV is forced to be pending to 'current' process using force_sig().
Is it ok or enough?

Thanks Al Viro.

Guan Xuetao

