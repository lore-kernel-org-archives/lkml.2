Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2GAQIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 12:08:16 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51346 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab2GAQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 12:08:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com>
	<4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com>
	<4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com>
	<877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com>
	<4FF06DF4.4000006@zytor.com>
Date: Sun, 01 Jul 2012 09:08:01 -0700
In-Reply-To: <4FF06DF4.4000006@zytor.com> (H. Peter Anvin's message of "Sun,
	01 Jul 2012 08:34:12 -0700")
Message-ID: <87wr2nsbvi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+eJa2jMJufXezLnbj+j9Dws2Hyl2xIawc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] x86, boot: Optimize the elf header handling.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 07/01/2012 08:04 AM, H. Peter Anvin wrote:
>>
>> Sadly, this patch breaks the boot with of of my standard configurations
>> (attached)... it goes into an infinite reboot loop.  This was the first
>> config I tested, so it might very well break more.
>>
>
> Some more investigation: the boot crashes because the .data..percpu
> segment is all zero -- since this includes the GDT, we die quickly and
> dramatically only a handful of instructions into head_64.S.
>
> I'm dropping this patchset for now.

Fair enough.  But ugh.

Can you point me at your config?
Can you tell me your linker version?

I tested this originally on both x86_64 and i386, and it 
worked both places for me.

I want to stair at that failure mode.  I am wondering what happened
in your configuration that is different from mine.  Perhaps a linker
bug?  A subtle conflict with something else?    The patch didn't do
anything that should have affectected per cpu sections...

Eric

