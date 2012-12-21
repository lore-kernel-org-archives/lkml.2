Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2LUW7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:59:07 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60002 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2LUW7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:59:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
References: <1356117854.21178.2@driftwood>
Date: Fri, 21 Dec 2012 14:58:56 -0800
In-Reply-To: <1356117854.21178.2@driftwood> (Rob Landley's message of "Fri, 21
	Dec 2012 13:24:14 -0600")
Message-ID: <87fw2zj9lb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+mnF0v9Ov1YwfrpQAJinkXXQ7PNpu8nGg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rob Landley <rob@landley.net>
X-Spam-Relay-Country: 
Subject: namespace documentation.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 12/21/2012 11:51:03 AM, Eric W. Biederman wrote:
>> Oleg Nesterov <oleg@redhat.com> writes:
>> 
>> > Eric. I understand that it is too late to discuss this. And yes, I  
>> simply
>> > do not understand the problem space, I never used containers.
>> >
>> > But, stupid question. Let's ignore the pid_ns-specific oddities.
>> >
>> > 1. Ignoring setns(), why do we need /proc/pid/ns/ ?
>> >
>> > 2. Why setns() requires /proc/pid/ns/ ? IOW, why it can't be
>> >
>> > 	sys_setns(pid_t pid, int clone_flags)
>> > 	{
>> > 		truct task_struct *tsk = find_task_by_vpid(pid);
>> > 		struct nsproxy *target = get_nsproxy(tsk->nsproxy);
>> >
>> > 		new_nsproxy = create_new_namespaces(...);
>> >
>> > 		if (clone_flags & CLONE_NEWNS)
>> > 			mntns_install(...);
>> > 		if (clone_flags & CLONE_NEWIPC)
>> > 			ipcns_install(...);
>> > 		...
>> > 	}
>> >
>> > I feel I missed something trivial, but what?
>> 
>> It is a question of naming.
>> 
>> The problem I set out to solve when all of this was introduced was how
>> to name namespaces without introducing yet another namespace.
>> 
>> The solution to the naming problem that I finally found was to  
>> introduce
>> something I could mount.
>
> Where might I find documentation on this? I'm aware of  
> Documentation/namespaces but it's only got one file in it (about  
> conflicts between namespace types). I'm aware of  
> http://lxc.sourceforge.net/index.php/about/kernel-namespaces/ and  
> http://lxc.sourceforge.net/man/ but that's mixed in with the  
> implementation details of a particular userspace tool, and tends to lag  
> the kernel significantly. (Those man pages were last updated in 2010,  
> which if I recall was the last time I poked them about it.)

I'm not certain what you are asking about.

The man pages that I endeavour to keep reasonably current are.

man 5 proc
man 2 setns
man 2 unshare
man 2 clone

You won't get a design discussion but you will get a description of how
the existing pieces work.  Of course now that I look it appears my
patches have not merged yet.  But that is reasonable since my recent
changes did not merge until a few days ago.

There is also iproute2 it's man pages and source.

There is the kernel source.

There are the occassional lwn articles.

I believe there should be a reasonable amount of email in the mailing
list archives when talking about the design descision, and when I
introduced setns.

Eric
