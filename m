Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2EHRxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:53:50 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:58959 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2EHRxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:53:48 -0400
Date: Tue, 8 May 2012 19:53:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tony Luck <tony.luck@gmail.com>, Michal Marek <mmarek@suse.cz>
Cc: Michal Marek <mmarek@suse.cz>, linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] kbuild: fix ia64 link
Message-ID: <20120508175346.GA11887@merkur.ravnborg.org>
References: <20120428205651.GA7426@merkur.ravnborg.org> <20120428205919.GC7442@merkur.ravnborg.org> <4FA460AB.6060309@suse.cz> <20120505082916.GA14006@merkur.ravnborg.org> <CA+8MBbKd9zAouJy5JvUnLwUHMJ65HsYgCTfBgv42nm32EnMPFA@mail.gmail.com> <20120508165118.GA11750@merkur.ravnborg.org> <CA+8MBbJHH1niHHR7md844UwphmeYczYQBJOB3huGFaxU9AXMTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbJHH1niHHR7md844UwphmeYczYQBJOB3huGFaxU9AXMTA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From aca8f5bd71797534ea220b193772946f59ee8125 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 8 May 2012 19:49:59 +0200
Subject: [PATCH] kbuild: fix ia64 link

ia64 build failed like this:

  CC      init/version.o
  LD      init/built-in.o
  KSYM    .tmp_kallsyms1.o
ld: .tmp_kallsyms1.o: linking constant-gp files with non-constant-gp files
ld: failed to merge target specific data of file .tmp_kallsyms1.o
make: *** [vmlinux] Error 1

This was introduced when link of vmlinux was migrated to a script.
Add missing option to as to fix this.

Reported-by: Tony Luck <tony.luck@gmail.com>
Tested-by: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

Hi Michal - please apply.

	Sam

 scripts/link-vmlinux.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 26c5b65..1f4c27b 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -78,8 +78,8 @@ kallsyms()
 		kallsymopt=--all-symbols
 	fi
 
-	local aflags="${KBUILD_AFLAGS} ${NOSTDINC_FLAGS}                     \
-		      ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
+	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
+		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 
 	${NM} -n ${1} | \
 		scripts/kallsyms ${kallsymopt} | \
-- 
1.6.0.6

