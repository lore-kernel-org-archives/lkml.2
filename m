Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2LNWCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:02:09 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36681 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab2LNWCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:02:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-security-module@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Date: Fri, 14 Dec 2012 14:01:57 -0800
Message-ID: <87txroxpgq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19l90tFC6xjQkFF8AapEpIKpJeRMuknbK0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 0/4] user namespace fixes
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are fixes from Andys review of my user namespace tree.

The first two patches are critical must fix fixes.

The third patch fixing commit_creds is a nice to have but fixing it
would be good.

Andy, Serge  if you could give these patches a once over to make certain
I am not doing something stupid.

Thank you,
Eric

---

Eric W. Biederman (4):
      Fix cap_capable to only allow owners in the parent user namespace to have caps.
      userns:  Require CAP_SYS_ADMIN for most uses of setns.
      userns: Add a more complete capability subset test to commit_creds
      userns: Fix typo in description of the limitation of userns_install

 fs/namespace.c           |    3 ++-
 ipc/namespace.c          |    3 ++-
 kernel/cred.c            |   26 +++++++++++++++++++++++++-
 kernel/pid_namespace.c   |    3 ++-
 kernel/user_namespace.c  |    2 +-
 kernel/utsname.c         |    3 ++-
 net/core/net_namespace.c |    3 ++-
 security/commoncap.c     |   25 +++++++++++++++++--------
 8 files changed, 53 insertions(+), 15 deletions(-)

