Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026Ab2LSEn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 23:43:58 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:49528 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2LSEnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 23:43:49 -0500
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
	<874njj3x9d.fsf@xmission.com>
	<20121218215316.GA4329@neilslaptop.think-freely.org>
Date: Tue, 18 Dec 2012 20:43:37 -0800
In-Reply-To: <20121218215316.GA4329@neilslaptop.think-freely.org> (Neil
	Horman's message of "Tue, 18 Dec 2012 16:53:16 -0500")
Message-ID: <87obhq1wjq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19XdIzZj+KMil2BLw047+S4oaeP8Qj9S/s=
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
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Neil Horman <nhorman@tuxdriver.com>
X-Spam-Relay-Country: 
Subject: Re: + core_pattern-set-core-helpers-root-and-namespace-to-crashing-process .patch added to -mm tree
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> On Tue, Dec 18, 2012 at 12:45:18PM -0800, Eric W. Biederman wrote:

>> The code for setns to change the pid namespace just merged.
>> 
> Can you post a link to the merge commit for reference so I can take a look at
> it?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=6a2b60b17b3e48a418695a94bd2420f6ab32e519

>> If we just want one pattern we should be able to to robustly implement
>> this in userspace with the existing functionality.  With the caveat that
>> we need to get some pid namespace and user namespace bugs in the core
>> pattern generation fixed.  But we need to fix those bugs anyway.
>> 
> Then perhaps the right thing to do here is in fact just make core_pattern a
> per-namespace sysctl.  I only took a brief look, but I was unable to find an
> example of such a per-namespace systctl.  Do we already have the infrastructure
> to do such a thing?  I didn't think we did.

We do have the infrastructure for a per namespace sysctls.  Right now we
only have per network namespace sysctls.  It is on my wish list to use
the infrastructure a little more extensively and convert /proc/sys into
a symlink to /proc/<pid>/sys and reduce the amount of magic in /proc for
sysctls.

We also have per namespace sysctls that do magic based upon current.
Since that pattern is has more magic I don't recommend it over the long
term.

Of course there is the question which namespace the sysctl should be
tied to, and what the other namespaces should be set to.  Shrug.

Eric
