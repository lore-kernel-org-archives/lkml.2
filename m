Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1AGVCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:02:38 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55771 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab1AGVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:02:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Paris <eparis@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
References: <1294302325-22593-1-git-send-email-amwang@redhat.com>
	<m1bp3uifln.fsf@fess.ebiederm.org>
	<AANLkTinLhAuSny735kofonAkaqwJvjjDHMUed_r03rVc@mail.gmail.com>
	<m1k4igjwzf.fsf@fess.ebiederm.org>
	<1294432333.3237.107.camel@localhost.localdomain>
Date: Fri, 07 Jan 2011 13:02:32 -0800
In-Reply-To: <1294432333.3237.107.camel@localhost.localdomain> (Eric Paris's
	message of "Fri, 07 Jan 2011 15:32:13 -0500")
Message-ID: <m18vywh1g7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18el2WT44xa4qHjfTvlqc55jX4eN+jI0Xo=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Paris <eparis@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [Patch] kexec_load: check CAP_SYS_MODULE
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

>> If I was building a configuration where I didn't want anyone to be able
>> to direct the kernel into a different state by locking down the
>> bootloaders I expect I would compile out the syscall as well.
>
> As sad as it may sound the vast majority of people don't build their own
> kernels.  And even those people who have the intelligence to do it are
> often constrained by some non-technical policy to run 'approved'
> kernels. 

Yes I am aware of the crazy game that is called approved kernels.  Where
there are too many regressions for people to trust new kernel releases
but people want to change the kernel and the setup from what was tested
and still have the stamp of approval anyway.  Financially it seems to
make people money, but as best I can tell that game is ultimately what
killed unix.

In this instance you seem to be redefining CAP_SYS_MODULE and
CAP_SYS_REBOOT so you can play that game. 

> Maybe I didn't make it clear how this is going to be used.  I plan to
> drop CAP_SYS_MODULE to stop root from loading their own modules and
> running their own code in the kernel.  I can control reboot() since I
> control the platform and the bootloader.  I cannot control kexec().  I'm
> also required to use a generic distro kernel (bet you can't guess which
> one)

If you are truly locked down I recommend dropping CAP_SYS_REBOOT and
setting up a watchdog that keeps the system from rebooting (standard
practice in embedded kinds of setups like you describe).  That should
meet everyone requirements without needing to game the system.

> The only solution I see to solve the problem is to gate kexec on
> CAP_SYS_MODULE.  Which makes sense since kexec() is in many respects
> close to module_init() than it is to reboot().

kexec_load is nothing like module_init().  All it does it puts data in
memory for use by a subsequent reboot.  /sbin/kexec is a bootloader that
runs inside of linux.  All you are noticing is that if you don't control
/sbin/kexec you aren't controlling the bootloader.

Eric
