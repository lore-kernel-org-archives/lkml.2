Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2KMCQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 21:16:16 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:47514 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2KMCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 21:16:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arvid Brodin <Arvid.Brodin@xdin.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David Rientjes" <rientjes@google.com>
References: <50A16BD0.7030600@xdin.com>
	<20121112150325.2516a0bf.akpm@linux-foundation.org>
Date: Mon, 12 Nov 2012 18:16:03 -0800
In-Reply-To: <20121112150325.2516a0bf.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 12 Nov 2012 15:03:25 -0800")
Message-ID: <871ufyjli4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Onl5asMJdYSjF4yKHcgaQI6ryESR/ICk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] fs/proc: Add process text segment md5-summing
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 12 Nov 2012 21:36:17 +0000
> Arvid Brodin <Arvid.Brodin@xdin.com> wrote:
>
>> Adds /proc/<pid>/text_md5sum which, when read, calculates an md5sum over
>> the process' text segment. This can detect some cases where the system RAM
>> has been disturbed by e.g. ESD or cosmic radiation (on systems where ECC
>> is not available). It might also detect some accidental or malicious
>> modifications of executables, where the perpetrator has not bothered to
>> cover up the tracks.
>
> I thought the review comments regarding the earlier patch were rather
> fatal, sorry.

To add another nail in the coffin.

You can do this with ptrace or with /proc/<pid>/mem without a kernel
patch.

To make this safe would need a ptrace_may_acces(PTRACE_MODE_READ)
permission check.  At which point not doing this with ptrace just adds
up to extra kernel maintenance for no real point.

Eric


