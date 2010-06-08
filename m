Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0FHUEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:04:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42421 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab0FHUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:04:24 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org> <4C0D8F43.4070900@zytor.com>
	<20100608091012.034f1cca@lxorguk.ukuu.org.uk>
	<4C0E87BB.4050303@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Jun 2010 13:04:15 -0700
In-Reply-To: <4C0E87BB.4050303@zytor.com> (H. Peter Anvin's message of "Tue\, 08 Jun 2010 11\:11\:07 -0700")
Message-ID: <m1sk4xe1fk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: hpa@zytor.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com, jacob.jun.pan@linux.intel.com, alan@lxorguk.ukuu.org.uk
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
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 06/08/2010 01:10 AM, Alan Cox wrote:
>>>> You may not use a 1-1 mapping if you don't have legacy irqs.  Linux
>>>> irqs 0-15 are the ISA irqs you may not use those irq numbers for
>> 
>> Linux IRQ 0 is "no IRQ assigned", except buried in certain bits of arch
>> specific historical knowledge.
>> 
>> Also calling 1-15 ISA IRQ lines is also somewhat misleading given they
>> are almost certainly routing for PCI devices. "PIC IRQ routing" maybe -
>> but even that is not really true on a lot of PC hardware today except by
>> convention.
>
> Yes, but I gather IRQ/GSI 0 is an early-acquire primary timer on MRST on
> Moorestown just as on PC/AT... just a different one.  Hence "special" in
> the same sort of way.  I don't really care, personally, though.

Right.  I have to admit I was stunned when I realized that request_irq
works and has worked for a long time with irq 0.  I think that might
actually be a bug.  setup_irq is traditionally used for irq 0.

Eric
