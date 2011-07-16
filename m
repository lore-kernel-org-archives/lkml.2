Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1GPQQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 12:16:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38235 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1GPQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 12:16:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        "tony.luck\@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa\@zytor.com" <hpa@zytor.com>,
        "dle-develop\@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
Date: Sat, 16 Jul 2011 09:16:06 -0700
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
	(Seiji Aguchi's message of "Mon, 11 Jul 2011 11:47:17 -0400")
Message-ID: <m14o2mjj5l.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/fKRFBpO/VxVvjpTS+hplzijNvDECyZ9w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seiji Aguchi <seiji.aguchi@hds.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] Replace a function call chain of kmsg_dump(KMSG_DUMP_KEXEC) with static function calls
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seiji Aguchi <seiji.aguchi@hds.com> writes:

> Hi,
>
> [Background]
>  - Requirement in enterprise area
>  From our support service experience, we always need to detect root causes of OS panic.
>  Because customers in enterprise area never forgive us if kdump fails and  we can't detect
>  root causes of panic due to lack of materials for investigation.
>
>  That is why I would like to add kmsg_dump() in kdump path.

You are whittling this down to something that has a chance of being
useful, but the code still has a ways to go.

It is good that you have managed to run tests that on one hardware
platform the firmware is reliable and that this does not reduce the odds
of kexec.  Your starting assertion however is that you can not do this
in the kernel started by kexec on panic because kexec on panic is
unreliable.  You don't have test cases that show your code working
when the kexec on panic kernel does not.

Calling out to EFI continues not to inspire my confidence that this
code will work on a wide variety of hardware platforms.

What is going on with EFI support?  We are still making efi calls in
virtual mode, and we don't have the one unified identity mapped physical
page table that hpa and I think others were working a while back.  Even
if because of bugs we need to transition EFI to virtual mode we can
still set physical to virtual so we don't have to deal with the nonsense.

Can we please make our EFI support ask the minimal from EFI before
adding lots more to it?

Am I wrong in thinking that the core motivation behind this patch is
that our EFI support sucks and thus kdump on EFI does not work on some
platforms?

Eric
