Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2LRHri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:47:38 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56757 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab2LRHrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:47:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <87wqwggtcu.fsf@xmission.com>
Date: Mon, 17 Dec 2012 23:47:26 -0800
In-Reply-To: <87wqwggtcu.fsf@xmission.com> (Eric W. Biederman's message of
	"Mon, 17 Dec 2012 15:18:57 -0800")
Message-ID: <87d2y7dcoh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Su8nAjexlaxIqEOO1+fl8VveLfOdbjHY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] user namespace and namespace infrastructure changes for 3.8
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Linus,
>
> Please pull the for-linus git tree from:
>
>    git://git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus
>
>    HEAD: 5155040ed349950e16c093ba8e65ad534994df2a userns: Fix typo in description of the limitation of userns_install
>
>    This tree is against v3.7-rc3
>
> The embarrasing oversights that Andy found have been corrected.

Those bugs, those darn embarrasing bugs just want don't want to get
fixed.

Linus I just updated my mirror of your kernel.org tree and it appears
you successfully pulled everything except the last 4 commits that fix
those embarrasing bugs.

When you get a chance can you please repull my branch (the details
above are still corect.

The pending changes are.

Eric W. Biederman (4):
      Fix cap_capable to only allow owners in the parent user namespace to have caps.
      userns: Require CAP_SYS_ADMIN for most uses of setns.
      userns: Add a more complete capability subset test to commit_creds
      userns: Fix typo in description of the limitation of userns_install

 fs/namespace.c           |    3 ++-
 ipc/namespace.c          |    3 ++-
 kernel/cred.c            |   27 ++++++++++++++++++++++++++-
 kernel/pid_namespace.c   |    3 ++-
 kernel/user_namespace.c  |    2 +-
 kernel/utsname.c         |    3 ++-
 net/core/net_namespace.c |    3 ++-
 security/commoncap.c     |   25 +++++++++++++++++--------
 8 files changed, 54 insertions(+), 15 deletions(-)

Eric
