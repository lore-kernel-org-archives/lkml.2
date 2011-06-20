Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1FTTlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:41:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58341 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab1FTTln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:41:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
	<alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
	<20110620103917.GA5230@albatros>
	<alpine.LRH.2.00.1106202040400.10448@tundra.namei.org>
	<20110620170600.GA25601@albatros>
Date: Mon, 20 Jun 2011 12:41:32 -0700
In-Reply-To: <20110620170600.GA25601@albatros> (Vasiliy Kulikov's message of
	"Mon, 20 Jun 2011 21:06:01 +0400")
Message-ID: <m1liww5lzn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/GGMKcfsZjjlXgiNH/R5E4/nhExvnaO54=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
	*  0.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Vasiliy Kulikov <segoon@openwall.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov <segoon@openwall.com> writes:

> (cc'ed Eric)
>
> On Mon, Jun 20, 2011 at 20:43 +1000, James Morris wrote:
>> > > > hidepid=1 means users may not access any /proc/<pid>/ directories, but their
>> > > > own.  Sensitive files like cmdline, io, sched*, status, wchan are now
>> > > > protected against other users.  As permission checking done in
>> > > > proc_pid_permission() and files' permissions are left untouched,
>> > > > programs expecting specific files' permissions are not confused.
>> > > 
>> > > IMHO such programs are beyond broken and have voided their kernel 
>> > > warranty.
>> > 
>> > Policykit, Debian's start-stop-daemon, util-linux use /proc/PID's uid.
>> > procps use both /proc/PID's uid and gid.  Are all of them totally broken?
>> 
>> If they depend on specific permissions, yes.
>
> Could you please then clarify why does this patch changes
> pid_revalidate() behaviour:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=99f895518368252ba862cc15ce4eb98ebbe1bec6
>
> It changes files permissions to allow userspace apps to quickly stat
> files, not looking into /proc/PID/status.  So, uid and gid are explicit
> ABI.  Breaking procfs uid/gid attributes would break these apps.
>
> Or am I missing something?

No, you are not missing something.  The uid and gid of proc files are
part of the userspace ABI.  The files are owned by the uid and gid
of the respective process.  The commit in question did not change
the ABI it documented it because I found out the hardware way that
a small change there breaks userspace.

Eric
