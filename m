Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2HKSCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 14:02:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57025 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2HKSCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 14:02:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org
References: <20120811091920.GA8117@localhost>
Date: Sat, 11 Aug 2012 11:02:28 -0700
In-Reply-To: <20120811091920.GA8117@localhost> (Fengguang Wu's message of
	"Sat, 11 Aug 2012 17:19:20 +0800")
Message-ID: <87ehnd1f4b.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+AR7TIbhF4fv/CJnkCcyvl7oZ7YcTnkB8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Fengguang Wu <fengguang.wu@intel.com>
X-Spam-Relay-Country: 
Subject: Re: suspicious RCU usage in copy_namespaces()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> Hi Eric,
>
> The below warning shows up since commit

Thanks. I am believe the usage is actually correct but I will dig some
more and see what it takes to convince the tools of that.

Eric


>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git userns-always-map-user-v45
> head:   38a0b1b84f5f613ff4e01fffda27f87d4cb2b649
> commit: 928ccdb582292cec4552bbf5831f7d374ff60269  userns: Allow unprivileged users to create new namespaces
>
> [    0.053560] ===============================
> [    0.054000] [ INFO: suspicious RCU usage. ]
> [    0.055001] 3.6.0-rc1-00116-g48de0c9 #176 Not tainted
> [    0.055999] -------------------------------
> [    0.057001] /c/kernel-tests/src/linux/kernel/nsproxy.c:126 suspicious rcu_dereference_check() usage!
> [    0.057999] 
> [    0.057999] other info that might help us debug this:
> [    0.057999] 
> [    0.058999] 
> [    0.058999] rcu_scheduler_active = 1, debug_locks = 1
> [    0.059998] no locks held by swapper/0.
> [    0.060998] 
> [    0.060998] stack backtrace:
> [    0.061999] Pid: 0, comm: swapper Not tainted 3.6.0-rc1-00116-g48de0c9 #176
> [    0.062999] Call Trace:
> [    0.063532]  [<b1047586>] lockdep_rcu_suspicious+0xba/0xc3
> [    0.064004]  [<b103218e>] copy_namespaces+0x59/0x1fd
> [    0.066002]  [<b101792b>] copy_process.part.49+0xec6/0xf02
> [    0.067002]  [<b1011f51>] ? kvm_clock_read+0x18/0x26
> [    0.068004]  [<b1488949>] ? start_kernel+0x304/0x304
> [    0.069000]  [<b1017a49>] do_fork+0xc6/0x23d
> [    0.070000]  [<b104698b>] ? trace_hardirqs_off+0xb/0xd
> [    0.071001]  [<b1037fc0>] ? local_clock+0x36/0x4e
> [    0.072003]  [<b120ab99>] ? _raw_spin_unlock_irqrestore+0x39/0x4f
> [    0.073053]  [<b1488949>] ? start_kernel+0x304/0x304
> [    0.074002]  [<b1006826>] kernel_thread+0x72/0x7a
> [    0.074999]  [<b1488949>] ? start_kernel+0x304/0x304
> [    0.076001]  [<b120fc5c>] ? common_interrupt+0x3c/0x3c
> [    0.077000]  [<b11fc816>] rest_init+0x1a/0x112
> [    0.077999]  [<b1488944>] start_kernel+0x2ff/0x304
> [    0.079000]  [<b14882c2>] i386_start_kernel+0x78/0x7d
> [    0.080376] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.086440] device: 'platform': device_add
>
> Thanks,
> Fengguang
