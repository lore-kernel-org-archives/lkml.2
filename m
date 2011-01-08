Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1AHAj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 19:39:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab1AHAj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 19:39:56 -0500
Subject: Re: [Patch] kexec_load: check CAP_SYS_MODULE
From: Eric Paris <eparis@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
In-Reply-To: <m18vywh1g7.fsf@fess.ebiederm.org>
References: <1294302325-22593-1-git-send-email-amwang@redhat.com>
	 <m1bp3uifln.fsf@fess.ebiederm.org>
	 <AANLkTinLhAuSny735kofonAkaqwJvjjDHMUed_r03rVc@mail.gmail.com>
	 <m1k4igjwzf.fsf@fess.ebiederm.org>
	 <1294432333.3237.107.camel@localhost.localdomain>
	 <m18vywh1g7.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 19:39:49 -0500
Message-ID: <1294447189.3237.132.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 13:02 -0800, Eric W. Biederman wrote:
> Eric Paris <eparis@redhat.com> writes:

> Yes I am aware of the crazy game that is called approved kernels.  Where
> there are too many regressions for people to trust new kernel releases
> but people want to change the kernel and the setup from what was tested
> and still have the stamp of approval anyway.  Financially it seems to
> make people money, but as best I can tell that game is ultimately what
> killed unix.

I don't believe this is a particularly relevant line of conversion and
should probably drop it, but I can't completely leave it alone.  We
obviously have a very different understanding of what concerning the
unix wars brought about its death.  I'd think it obvious that the very
fact that this conversation is taking place shows that the exact
opposite of the unix wars problems are being seen here.  You clearly
have personal opinions about the benefits of custom built kernels, but
they are not the opinions of the vast majority of linux users.  I rarely
run disto kernels and I'm sure few on lkml do, but it doesn't change the
fact that most users, especially large IT environments, require system
standardization.  I hope to address the needs of this portion of the
linux community even if you might wish they functioned differently.

> In this instance you seem to be redefining CAP_SYS_MODULE and
> CAP_SYS_REBOOT so you can play that game.

Clearly I am refining the meaning of both in some way.  Personally I
think the current differentiation is wrong.

> > Maybe I didn't make it clear how this is going to be used.  I plan to
> > drop CAP_SYS_MODULE to stop root from loading their own modules and
> > running their own code in the kernel.  I can control reboot() since I
> > control the platform and the bootloader.  I cannot control kexec().  I'm
> > also required to use a generic distro kernel (bet you can't guess which
> > one)
> 
> If you are truly locked down I recommend dropping CAP_SYS_REBOOT and
> setting up a watchdog that keeps the system from rebooting (standard
> practice in embedded kinds of setups like you describe).  That should
> meet everyone requirements without needing to game the system.

This does not meet the set of requirements.  I recognize that you don't
have the full architecture in mind (and apologize that I can't describe
it much better than I am already), but root should still be allowed to
reboot the machine.  This is not an embedded platform.  Nor one in which
a watchdog task makes any sense at all.

> > The only solution I see to solve the problem is to gate kexec on
> > CAP_SYS_MODULE.  Which makes sense since kexec() is in many respects
> > close to module_init() than it is to reboot().
> 
> kexec_load is nothing like module_init().  All it does it puts data in
> memory for use by a subsequent reboot.  /sbin/kexec is a bootloader that
> runs inside of linux.  All you are noticing is that if you don't control
> /sbin/kexec you aren't controlling the bootloader.

Does that mean you would instead prefer that we check CAP_SYS_MODULE in
sys_reboot() when LINUX_REBOOT_CMD_KEXEC is set (or really
kernel_kexec())?  It seems to me you indicate that is the more analogous
location since it is the actual place where we load new kernel code on
the running system (aka what sys_module was intended to protect)?

-Eric

