Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2LRUpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:45:34 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60527 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2LRUpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:45:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <20121217123428.GA1957@redhat.com>
	<20121217150559.GD25322@hmsreliant.think-freely.org>
	<20121217160408.GA20166@redhat.com>
	<20121217183925.GE25322@hmsreliant.think-freely.org>
	<20121218200604.GA28834@redhat.com>
	<20121218201900.GA10059@hmsreliant.think-freely.org>
Date: Tue, 18 Dec 2012 12:45:18 -0800
In-Reply-To: <20121218201900.GA10059@hmsreliant.think-freely.org> (Neil
	Horman's message of "Tue, 18 Dec 2012 15:19:01 -0500")
Message-ID: <874njj3x9d.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Nf3qaDjRvW8JBm0XP7VVRSI7R21amJNs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.1 XMSubLong Long Subject
	*  1.0 XMGappySubj_02 Gappier still
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Neil Horman <nhorman@tuxdriver.com>
X-Spam-Relay-Country: 
Subject: Re: + core_pattern-set-core-helpers-root-and-namespace-to-crashing-process .patch added to -mm tree
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> On Tue, Dec 18, 2012 at 09:06:04PM +0100, Oleg Nesterov wrote:
>> On 12/17, Neil Horman wrote:
>> >
>> > On Mon, Dec 17, 2012 at 05:04:08PM +0100, Oleg Nesterov wrote:
>> > >
>> > > > Is there a way to switch all namespaces, except for the pid
>> > > > namespace?
>> > >
>> > > Which exactly namespaces you want to change?
>> > >
>> > Ideally, I want the pipe reader process to execute in the same namespaces that
>> > the crashing process executed in (i.e. the pipe reader should execute as though
>> > the crashing process forked it).
>> 
>> Yes, and we probably want to change pid_ns as well. But afaics currently
>> this is not possible, even setns can't do this.

The code for setns to change the pid namespace just merged.

Oleg I copied you on that code when I put it up for review.  Did I use
the wrong email address?

>> BTW. Of course this is subjective, but personally I think that "||"
>> looks strange. Perhaps it would be better to add something like
>> --croot argument?
>> 
> The || is ambiguous with its simmilarity to a shell 'or' command, but I don't
> think the --croot argument is much better on that front, as that then becomes
> ambiguous with arguments supplied to the pipe reader directly.  The token should
> be leading the pipe_reader string in core_pattern to indicate a change in
> environment independent of the executable path.  Perhaps |^ or something
> simmilar?

I failed to send my earlier reply but there is another problem with the
approach of only having one global core dump pattern.  You can't set it
per container.  Which means a special character to switch namespeces
while a reasonable solution (and arguably unnecessary solution) is not a
complete solution.

> Either way, Andrew, could you please drop this patch?  Olegs comments I think
> make it pretty clear I've got some more work to do on this.

If we just want one pattern we should be able to to robustly implement
this in userspace with the existing functionality.  With the caveat that
we need to get some pid namespace and user namespace bugs in the core
pattern generation fixed.  But we need to fix those bugs anyway.

Eric
