Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1BQPBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:01:17 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:58277
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755078Ab1BQPBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:01:14 -0500
Date: Thu, 17 Feb 2011 15:02:24 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: LSM <linux-security-module@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com, serge@hallyn.com
Subject: userns: targeted capabilities v5
Message-ID: <20110217150224.GA26334@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a repost of my previous user namespace patch, ported onto
last night's git head.

It fixes several things I was doing wrong in the last (v4)
posting, in particular:

	1. don't set uts_ns->user_ns to current's when !CLONE_NEWUTS
	2. add a ipc_ns->user_ns which owns ipc_ns, and use that to
	   decide CAP_IPC_OWNER
	3. fix logic flaw caused by bad parantheses
	4. allow do_prlimit to current
	5. don't always give root full privs to init_user_ns

The expected course of development for user namespaces is laid out
at https://wiki.ubuntu.com/UserNamespace.  Bugs aside, this
patchset is supposed to not at all affect systems which are not
actively using user namespaces, and only restrict what tasks in
child user namespace can do.  They begin to limit privilege to
a user namespace, so that root in a container cannot kill or
ptrace tasks in the parent user namespace, and can only get
world access rights to files.  Since all files currently belong
to the initila user namespace, that means that child user
namespaces can only get world access rights to *all* files.
While this temporarily makes user namespaces bad for system
containers, it starts to get useful for some sandboxing.

I've run the 'runltplite.sh' with and without this patchset and
found no difference.  So all in all, this is the first version
of this patchset for which I feel comfortable asking:  please
consider applying.

thanks,
-serge
