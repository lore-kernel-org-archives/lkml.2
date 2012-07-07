Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab2GGOj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 10:39:28 -0400
Received: from tundra.namei.org ([65.99.196.166]:49558 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab2GGOj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 10:39:26 -0400
Date: Sun, 8 Jul 2012 00:39:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] security: Minor improvements to no_new_privs documentation
In-Reply-To: <56ad7562a2a40a29b8ce72f4ec5e5836c5cb72f6.1341512511.git.luto@amacapital.net>
Message-ID: <alpine.LRH.2.02.1207080038180.14390@tundra.namei.org>
References: <4FF3A627.40809@landley.net> <56ad7562a2a40a29b8ce72f4ec5e5836c5cb72f6.1341512511.git.luto@amacapital.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull for 3.5.


The following changes since commit 26c439d4005d94b8da28e023e285fd4a9943470e:
  Linus Torvalds (1):
        Merge tag 'ecryptfs-3.5-rc6-fixes' of git://git.kernel.org/.../tyhicks/ecryptfs

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Andy Lutomirski (1):
      security: Minor improvements to no_new_privs documentation

 Documentation/prctl/no_new_privs.txt |    7 +++++++
 include/linux/prctl.h                |    2 ++
 2 files changed, 9 insertions(+)

commit c540521bba5d2f24bd2c0417157bfaf8b85e2eee
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Thu Jul 5 11:23:24 2012 -0700

    security: Minor improvements to no_new_privs documentation
    
    The documentation didn't actually mention how to enable no_new_privs.
    This also adds a note about possible interactions between
    no_new_privs and LSMs (i.e. why teaching systemd to set no_new_privs
    is not necessarily a good idea), and it references the new docs
    from include/linux/prctl.h.
    
    Suggested-by: Rob Landley <rob@landley.net>
    Signed-off-by: Andy Lutomirski <luto@amacapital.net>
    Acked-by: Kees Cook <keescook@chromium.org>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/Documentation/prctl/no_new_privs.txt b/Documentation/prctl/no_new_privs.txt
index cb705ec..f7be84f 100644
--- a/Documentation/prctl/no_new_privs.txt
+++ b/Documentation/prctl/no_new_privs.txt
@@ -25,6 +25,13 @@ bits will no longer change the uid or gid; file capabilities will not
 add to the permitted set, and LSMs will not relax constraints after
 execve.
 
+To set no_new_privs, use prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0).
+
+Be careful, though: LSMs might also not tighten constraints on exec
+in no_new_privs mode.  (This means that setting up a general-purpose
+service launcher to set no_new_privs before execing daemons may
+interfere with LSM-based sandboxing.)
+
 Note that no_new_privs does not prevent privilege changes that do not
 involve execve.  An appropriately privileged task can still call
 setuid(2) and receive SCM_RIGHTS datagrams.
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 3988012..289760f 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -141,6 +141,8 @@
  * Changing LSM security domain is considered a new privilege.  So, for example,
  * asking selinux for a specific new context (e.g. with runcon) will result
  * in execve returning -EPERM.
+ *
+ * See Documentation/prctl/no_new_privs.txt for more details.
  */
 #define PR_SET_NO_NEW_PRIVS	38
 #define PR_GET_NO_NEW_PRIVS	39
