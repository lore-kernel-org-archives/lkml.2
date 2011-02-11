Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1BKQqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 11:46:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45828 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1BKQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 11:46:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Olsa <jolsa@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <1297432830-3912-1-git-send-email-jolsa@redhat.com>
Date: Fri, 11 Feb 2011 08:46:41 -0800
In-Reply-To: <1297432830-3912-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Fri, 11 Feb 2011 15:00:30 +0100")
Message-ID: <m14o8a34em.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+8kVNrCN/FAPL+HvO9Azqk41rfjcyXAO0=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jiri Olsa <jolsa@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] x86_64: disable identity mappings statically
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> hi,
>
> while browsing the page table setup code, I noticed the x86_64 head
> code might not need the identity mappings at all.
> It seems it's ok to switch it off completely from the begining,
> unless I'm missing something.

Have you tested it?

I expect you will find that we need the identity mapping because
before we load this page table we are running with virt==phys
and we need the identity mapping retained  in the new page table
so we can get to the instruction after movq %rax, %cr0.

Eric
