Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab1BPAow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:44:52 -0500
Received: from kroah.org ([198.145.64.141]:49298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab1BPAW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:42 2011
Message-Id: <20110216001442.334464970@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kacper Kornet <kornet@camk.edu.pl>, Jiri Slaby <jslaby@suse.cz>
Subject: [172/272] Fix prlimit64 for suid/sgid processes
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kacper Kornet <kornet@camk.edu.pl>

commit aa5bd67dcfdf9af34c7fa36ebc87d4e1f7e91873 upstream.

Since check_prlimit_permission always fails in the case of SUID/GUID
processes, such processes are not able to read or set their own limits.
This commit changes this by assuming that process can always read/change
its own limits.

Signed-off-by: Kacper Kornet <kornet@camk.edu.pl>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sys.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1377,7 +1377,8 @@ static int check_prlimit_permission(stru
 	const struct cred *cred = current_cred(), *tcred;
 
 	tcred = __task_cred(task);
-	if ((cred->uid != tcred->euid ||
+	if (current != task &&
+	    (cred->uid != tcred->euid ||
 	     cred->uid != tcred->suid ||
 	     cred->uid != tcred->uid  ||
 	     cred->gid != tcred->egid ||


