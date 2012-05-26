Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2EZPav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 11:30:51 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53516 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2EZPau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 11:30:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Colin Walters <walters@verbum.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <87hav8vypc.fsf@xmission.com> <1337894526.9093.7.camel@lenny>
Date: Sat, 26 May 2012 09:30:39 -0600
In-Reply-To: <1337894526.9093.7.camel@lenny> (Colin Walters's message of "Thu,
	24 May 2012 17:22:06 -0400")
Message-ID: <87k3zzt0ww.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bXxuf0r3P3VO7xn+uHtN/Z+048VLJTnA=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1940]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Colin Walters <walters@verbum.org>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] user namespace enhancements for Linux 3.5-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Walters <walters@verbum.org> writes:

> On Tue, 2012-05-22 at 12:48 -0600, Eric W. Biederman wrote:
>
>> My git tree covers all of the modifications needed to convert the core
>> kernel and enough changes to make a system bootable to runlevel 1.
>
> What system?  I'm curious about the state of your userspace
> modifications.

Debian.

Userspace won't need any modifications to work, but I am slowly working
through the patches needed to get everything in the kernel converted.
And my patches for the networking stack weren't quite ready for the
merge window.

Ultimately to be included in distro kernels and really be useful I need
to make everything in the kernel that plays with uids and gids user
namespace aware so that is my goal for the next merge window.  We will
see how that goes.

As for patches to userspace, all I think I will need is a small change
to useradd, and perhaps a helper function to validate the mapping into
the initial user namespace's uids. Aka is user A allowed to use uids
100,000-110,000?

I have a branch in my user-namespace.git with all of the rest of my
kernel changes if you want to play.  Beyond that I expect most of the
user space changes (useradd etc) to land in ubuntu fairly shortly
after they are viable as I am working closely with a couple folks
at ubunut.

Eric





