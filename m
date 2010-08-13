Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0HMXLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:11:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51873 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab0HMXLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:11:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Luck\, Tony" <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>,
        "nhorman\@tuxdriver.com" <nhorman@tuxdriver.com>
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
	<4C65C630.4070008@zytor.com>
	<987664A83D2D224EAE907B061CE93D53015B2DAD87@orsmsx505.amr.corp.intel.com>
Date: Fri, 13 Aug 2010 16:11:20 -0700
In-Reply-To: <987664A83D2D224EAE907B061CE93D53015B2DAD87@orsmsx505.amr.corp.intel.com>
	(Tony Luck's message of "Fri, 13 Aug 2010 15:33:56 -0700")
Message-ID: <m1r5i2kt0n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Luck\, Tony" <tony.luck@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH][EFI] Run EFI in physical mode
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luck, Tony" <tony.luck@intel.com> writes:

>> does this affect ia64 in any way?
>
> I remember Eric complaining that set_virtual_address_map() was a one
> way trap door with no way to get back to physical mode ... and thus
> this was a big problem to support kexec on ia64. And yet we still call
> it, and ia64 can do kexec. So some other work around must have been
> found. Can't immediately remember what it was though.

There is a hack in the code someplace on ia64 to pass the virtual
address efi was mapped at to the next kernel, and have the kernel make
certain to use efi there, without calling set_virtual_address_map().
For similar kernels that is fine at some point I expect kernel
divergence will make that scheme unworkable.  Essentially this is the
same as using physical addresses but starting with the virtual addresses.

For ia64 I seem to recall some weird floating point fixup routines that
benefited from the speed set_virtual_address_map() provided.  For x86_64
where the primary (sole?) reason for enabling EFI handling is to set efi
variables from linux, I don't see a case where enabling virtual mode
makes sense.  If EFI stays around on x86, always running the calls in
physical mode and in other ways slowly decreasing our dependence on
perfect efi implementations seems necessary.

As to Peter's question I did not see any of that code that affected
anything that ia64 used.

Eric
