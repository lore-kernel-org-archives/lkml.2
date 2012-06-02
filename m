Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab2FBXsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 19:48:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34668 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933325Ab2FBXsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 19:48:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: hacklu <embedway.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
References: <4FB492F7.8050401@gmail.com>
Date: Sat, 02 Jun 2012 17:48:04 -0600
In-Reply-To: <4FB492F7.8050401@gmail.com> (hacklu's message of "Thu, 17 May
	2012 13:56:07 +0800")
Message-ID: <87ipf9gtsb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX194Yb64BzOj+qpqqofL65tTskdmrPNKUo0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1256]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;hacklu <embedway.linux@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: why the decompressed procedure move kernel from address 0x100000(1M) to 0x1000000(16M) +x
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hacklu <embedway.linux@gmail.com> writes:

> hi all,
> recently, I got some puzzle when I read source code of the system boot. I need
> some help.
>
> at the end of src/arch/x86/boot/header.S,  kernel jump to 0x100000(where is the
> src/arch/x86/boot/compressed/head_32.S).
> in __this__ head_32.S, I found the kernel is move to 0x1000000(mostly is to
> here) +x. the x distance is used for decompressed buf.  must leave some distance
> for decompressing without overlap.
>
> after the move, kernel is decompressed at 0x1000000(16m). and jump to it.
>
> so why not decompressed kernel at 0x100000(1M) to 0x1000000(16m) directly
> without moving?
>
> is the move necessary?

The move is nececcessary if we are doing the decompression in place.
Without a move it is hard to tell if there are going to be overlapping
address problems.  The move is cheap so there is no apparent reason
to optimize it away.

Eric
