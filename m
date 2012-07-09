Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2GIGvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:51:02 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60499 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2GIGvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:51:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, hacklu <embedway.linux@gmail.com>,
        linux-kernel@vger.kernel.org
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com>
	<4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com>
	<4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com>
	<877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com>
	<4FF06DF4.4000006@zytor.com> <87wr2nsbvi.fsf@xmission.com>
	<4FF0769F.8090105@zytor.com> <87sjdbsb0v.fsf@xmission.com>
	<4FF07E66.2020706@zytor.com> <87d34fs914.fsf@xmission.com>
	<4FF085B1.6070604@zytor.com> <87a9zj9w43.fsf@xmission.com>
	<4FF098E2.3040307@zytor.com> <87sjdb8f0m.fsf@xmission.com>
	<4FF0A399.8070207@zytor.com> <87txxr6wre.fsf@xmission.com>
	<4FF0B891.8080804@zytor.com>
Date: Sun, 08 Jul 2012 23:50:38 -0700
In-Reply-To: <4FF0B891.8080804@zytor.com> (H. Peter Anvin's message of "Sun,
	01 Jul 2012 13:52:33 -0700")
Message-ID: <87k3yd5sxt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+tmGio0Pwyygw7ZpjRTLrlRBsFwSE1pFE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] x86, boot: Optimize the elf header handling.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 07/01/2012 01:40 PM, Eric W. Biederman wrote:
>> 
>> So I have tracked down part of the crazyness.
>> CONFIG_RODATA actually uses 2MB alignment, making
>> -z max_page_size=4096 a bit questionable.
>> 
>
> Questionable how?  It's not really like it matters since we're not going
> to mmap the ELF.

Questionable as in the current elf loader in misc.c relies on the fact
that there is an almost a fixed offset between physical addresses and
file offsets for all of the PT_LOAD segments in the Elf header.

In fact CONFIG_RODATA && CONFIG_X86_64 && CONFIG_SMP in combination with
-z max_page_size=4096 fails to boot.  The Elf loader in misc.c starts
coping from lower addresses to higher addresses, instead of higher
addresses to lower and that fails miserably.

But -z max_page_size=4096 is not the problem the ELF loader is.

Eric
