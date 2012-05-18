Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968194Ab2ERWra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:47:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60728 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab2ERWr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:47:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
References: <4FAD0524.3000307@parallels.com> <4FAD0555.4090906@parallels.com>
	<87mx5e5tho.fsf_-_@xmission.com> <4FAE4C70.5000804@parallels.com>
	<20120518194417.GA14195@mail.hallyn.com>
Date: Fri, 18 May 2012 16:47:02 -0600
In-Reply-To: <20120518194417.GA14195@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 18 May 2012 19:44:17 +0000")
Message-ID: <87sjexp0nt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+6BNB1J2uTR2sHxSQDqRLtJF/Z6Vv9nvo=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] vfs: Add setns support for the mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Pavel Emelyanov (xemul@parallels.com):
>> On 05/12/2012 12:54 AM, Eric W. Biederman wrote:
>> > 
>> > setns support for the mount namespace is a little tricky as an arbitrary
>> > decision must be made about what to set fs->root and fs->pwd to, as
>> > there is no expectation of a relationship between the two mount
>> > namespaces.  Therefore I arbitrarily find the root mount point, and
>> > follow every mount on top of it to find the top of the mount stack.
>> > Then I set fs->root and fs->pwd to that location.  The topmost root of
>> > the mount stack seems like a reasonable place to be.
>> > 
>> > Bind mount support for the mount namespace inodes has the possibility of
>> > creating circular dependencies between mount namespaces.  Circular
>> > dependencies can result in loops that prevent mount namespaces from
>> > every being freed.  I avoid creating those circular dependencies by
>> > adding a sequence number to the mount namespace and require all bind
>> > mounts be of a younger mount namespace into an older mount namespace.
>> > 
>> > Add a helper function proc_ns_inode so it is possible to detect when we
>> > are attempting to bind mound a namespace inode.
>> > 
>> > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Acked-by: Pavel Emelyanov <xemul@parallels.com>
>
> These patches haven't made it into linux-next or Linus' tree.  (More
> worrisome, is that the several online linux-kernel mail archives I've
> checked seem to have most of this thread, but not Eric's original
> patch.)  What path were they expected to go in by?

I was hoping Al Viro would pick it up in the vfs tree, or at least
review the patch.  With a backup possibility that Andrew Morton might.

Given that the merge window is likely to open in next couple of days
I plan to resubmit this after the merge window closes. 

I don't have a clue what happened to the archives that day but it does
look like there was a significant mail hiccup as the number of messages
archived are way down.

Eric
