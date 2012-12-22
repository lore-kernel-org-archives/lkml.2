Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2LVE45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:56:57 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:37329 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2LVE4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:56:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>
Date: Fri, 21 Dec 2012 20:56:49 -0800
Message-ID: <87d2y2elbi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Kp6EoJ84m4i4J2nxXPVXeOWCQG/LxVTs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: [PATCH review 0/3] pid namespaces fixes
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oleg assuming I am not blind these patches should fix the issues you
spotted in the pid namespace as well as one additional one that I found
during testing.

Anyone with an extra set of eyeballs that wants to look over this code
and double check to make certain I am not doing something stupid would
be welcome.

These patches are against 3.8-rc1 and I hope to get the into linux-next
and on to Linus shortly.

Eric W. Biederman (3):
      pidns: Outlaw thread creation after unshare(CLONE_NEWPID)
      pidns: Stop pid allocation when init dies
      proc: Allow proc_free_inum to be called from any context

 fs/proc/generic.c             |   13 +++++++------
 include/linux/pid.h           |    1 +
 include/linux/pid_namespace.h |    4 +++-
 kernel/fork.c                 |    8 ++++++++
 kernel/pid.c                  |   13 ++++++++++---
 kernel/pid_namespace.c        |    4 ++++
 6 files changed, 33 insertions(+), 10 deletions(-)
