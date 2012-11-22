Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2KVXem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:34:42 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38322 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab2KVXej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 18:34:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-2-git-send-email-yinghai@kernel.org>
	<50AD0E22.3020807@zytor.com>
	<CAE9FiQVreVFJ5tASirYkzTUvYw1XombdArqN3N1HnAP9wLijhQ@mail.gmail.com>
	<50AD307C.6060008@zytor.com>
	<CAE9FiQUaajsWe3854xxUOyPEZ7Dbt3GE0VWs8KvQbtqVrOXQdw@mail.gmail.com>
Date: Wed, 21 Nov 2012 21:48:51 -0800
In-Reply-To: <CAE9FiQUaajsWe3854xxUOyPEZ7Dbt3GE0VWs8KvQbtqVrOXQdw@mail.gmail.com>
	(Yinghai Lu's message of "Wed, 21 Nov 2012 12:15:28 -0800")
Message-ID: <87d2z6jigs.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19XaHEHVL0tyc8ljmeeMEOfKIdlJApNfbo=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 01/12] x86, boot: move verify_cpu.S after 0x200
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Wed, Nov 21, 2012 at 11:50 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> The comment is just plain wrong.  It assumes you're loading an ELF file,
>> whereas in practice that is rarely true.
>>
>> This does explain why the poor ABI, though.  A jump table at the
>> beginning would have been a lot cleaner.
>
> Can you please have patch to update the comments and point to the API there ?

Long ago and far away.  I wrote the 64bit entry code for a bzImage by
putting an ELF header in the boot sector.  That is what that comment
referred to when it was written.  Andrew had a problem on one of his
test machines and so the patch to bootsector was dropped.

Booting with a vmlinux file does (or at least should not) need this.
ELF loaders will pick the entry point out from the ELF header.

I don't know what has happened in the intervening time, or who if anyone
has depended on that offset.  The original intent an internal use hard
code.

Eric



