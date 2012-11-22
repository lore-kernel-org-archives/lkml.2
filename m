Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2KVTE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:04:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34082 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2KVTEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:04:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-2-git-send-email-yinghai@kernel.org>
	<50AD0E22.3020807@zytor.com>
	<CAE9FiQVreVFJ5tASirYkzTUvYw1XombdArqN3N1HnAP9wLijhQ@mail.gmail.com>
	<50AD307C.6060008@zytor.com>
	<CAE9FiQUaajsWe3854xxUOyPEZ7Dbt3GE0VWs8KvQbtqVrOXQdw@mail.gmail.com>
	<87d2z6jigs.fsf@xmission.com>
	<3178cb29-0e9e-44d2-b21f-45c53f38980a@email.android.com>
Date: Thu, 22 Nov 2012 03:27:58 -0800
In-Reply-To: <3178cb29-0e9e-44d2-b21f-45c53f38980a@email.android.com>
	(H. Peter Anvin's message of "Wed, 21 Nov 2012 21:59:49 -0800")
Message-ID: <874nkh3mip.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+2EIFKrKF4vrdIRN8jwBj5dZotCpLusfc=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 01/12] x86, boot: move verify_cpu.S after 0x200
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Quite certain something depends on it.

It would not surprise me at all that there is a dependency, if we have
not had a better way to report the 64bit entry point.  I just wanted to
make the context clear as that was confused in the discussion.

Note that having a 32bit entry point at offset 0 is as much of an ABI.

I am surprised that there are legitimate reasons to bulk up the 32bit
entry point code before the 0x200.  Everything that we are doing at that
point is architectural.

Eric
