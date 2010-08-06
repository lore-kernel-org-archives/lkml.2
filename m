Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab0HFFN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:13:59 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37376 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0HFFN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:13:57 -0400
Date: Fri, 6 Aug 2010 07:13:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Michal Marek <mmarek@suse.cz>, JBeulich@novell.com, aris@redhat.com,
        catalin.marinas@arm.com, jacmet@sunsite.dk, lizf@cn.fujitsu.com,
        ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: fix make oldconfig
Message-ID: <20100806051354.GA24343@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com> <4C5B64EA.2000804@gmail.com> <AANLkTikpsvpHuB-mWVfmqTRRMvbvhJz2LmoYBgtn4NQE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikpsvpHuB-mWVfmqTRRMvbvhJz2LmoYBgtn4NQE@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] kconfig: fix make oldconfig

Linus wrote:
 This seems to make "make oldconfig" a _lot_ more verbose than it
 used to be. In a very annoying way.

 I just did a quick git bisect. It's introduced by commit 4062f1a4c030
 ("kconfig: use long options in conf") by Sam Ravnborg. Apparently that
 thing is totally buggy, and doesn't just change the option names, but
 actively breaks them.

The old behaviour (from years ago) were reintroduced by accident.
Fix this so we are back to the version that are silent
if there is nothing to ask about.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

Sorry for this regression. Dunno how I missed it.
I guess I only tested "silentoldconfig".

Following patch seems obviously correct but as I am on the way
out of the door I could not do much testing.

	Sam

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 010600e..274f271 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -599,12 +599,12 @@ int main(int ac, char **av)
 		break;
 	case savedefconfig:
 		break;
-	case oldconfig:
 	case oldaskconfig:
 		rootEntry = &rootmenu;
 		conf(&rootmenu);
 		input_mode = silentoldconfig;
 		/* fall through */
+	case oldconfig:
 	case listnewconfig:
 	case oldnoconfig:
 	case silentoldconfig:
