Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934887Ab2J3Wpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:45:47 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58076 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab2J3Wpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:45:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arvid Brodin <Arvid.Brodin@xdin.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David Rientjes" <rientjes@google.com>
References: <50904066.4060404@xdin.com>
Date: Tue, 30 Oct 2012 15:45:35 -0700
In-Reply-To: <50904066.4060404@xdin.com> (Arvid Brodin's message of "Tue, 30
	Oct 2012 21:02:33 +0000")
Message-ID: <87ip9refzk.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18P/+LtNJXnR9zHVq77grjrYiNoqdnw4Dc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0411]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Arvid Brodin <Arvid.Brodin@xdin.com>
X-Spam-Relay-Country: 
Subject: Re: fs/proc/base.c: text md5sums; tgid vs tid; and INF vs ONE?
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arvid Brodin <Arvid.Brodin@xdin.com> writes:

> Hi,
>
> Below is a patch that adds a file /proc/PID/text_md5sum which when read returns the md5
> checksum of a process' text segment. (This would be used e.g. to make sure a process'
> code hasn't been tampered with.)
>
> However, I have a few questions:
>
> * What's the difference between the tgid_base_stuff and tid_base_stuff arrays? (One for
> processes and one for the process' threads? I haven't been able to find any info about
> this so I'm guessing.)

Yes.  One for thread groups and one for threads.

> * When should I use the INF ("read") vs the ONE ("show") macro?

proc_read depends on the caller to allocate a 4k buffer, instead of
sizing the buffer based upon the size of the text being written.  Which
makes proc_read an error prone and ultimately deprecated way of handling
things.

Using some variant on seq_file is preferred for new files.

> * Any other comments about the code?

There are known successful attacks against md5 so using md5 for
something new and security related is a bad idea.

Userspace can just as easily compute a security hash itself you don't
need kernel support.


I recommend you checkout the code in security/ima/ looks like it can
already do what you are trying to do.

Eric
