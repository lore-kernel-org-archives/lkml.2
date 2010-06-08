Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab0FHVvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:51:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60484 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab0FHVvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:51:08 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: jacob pan <jacob.jun.pan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
	<m1631tfh1i.fsf@fess.ebiederm.org> <4C0EA9BD.1090306@zytor.com>
	<m1iq5tckb1.fsf@fess.ebiederm.org> <4C0EB168.5080801@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Jun 2010 14:51:01 -0700
In-Reply-To: <4C0EB168.5080801@zytor.com> (H. Peter Anvin's message of "Tue\, 08 Jun 2010 14\:08\:56 -0700")
Message-ID: <m18w6p8a7u.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: hpa@zytor.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com, jacob.jun.pan@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 06/08/2010 01:59 PM, Eric W. Biederman wrote:
>> 
>> No.  There is no reason to loose 16 IDT entries indefinitely.  We may
>> need a boot time allocation when we see we have isa irqs, to replace
>> the static allocation that we have.  But for the most part we dynamically
>> idt entries aka vector numbers today, and there is no reason we can't
>> generalize that in the future.
>> 
>
> Well, that boot time allocation is one of the things
> legacy_pic->nr_legacy_irq is used for, and it really makes sense, I
> think.  I would really like to move away from a compile-time allocation,
> and I still find it hard to believe it has a reason to exist.

Interesting.  Using legacy_pic->nr_legacy_irqs certainly isn't the
right way to handle that.  We should just have an init method for the
legacy_pic that just allocates what it needs when it is initialized.

I think we can now run in either just pic mode or just apic mode and
so can kill any code for switching from one mode to another.  That led
to all kinds of complexity.

As time and priorities permit I will send/review patches cleaning up the linux
irq code. 

Eric
