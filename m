Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2EHQvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:51:22 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:16136 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab2EHQvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:51:19 -0400
Date: Tue, 8 May 2012 18:51:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/4] kbuild: link of vmlinux moved to a script
Message-ID: <20120508165118.GA11750@merkur.ravnborg.org>
References: <20120428205651.GA7426@merkur.ravnborg.org> <20120428205919.GC7442@merkur.ravnborg.org> <4FA460AB.6060309@suse.cz> <20120505082916.GA14006@merkur.ravnborg.org> <CA+8MBbKd9zAouJy5JvUnLwUHMJ65HsYgCTfBgv42nm32EnMPFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbKd9zAouJy5JvUnLwUHMJ65HsYgCTfBgv42nm32EnMPFA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony.

On Mon, May 07, 2012 at 04:15:44PM -0700, Tony Luck wrote:
> This patch is now in linux-next (tag next-20120507). But it looks to have
> broken the ia64 build. I see this error:
> 
>   CC      init/version.o
>   LD      init/built-in.o
>   KSYM    .tmp_kallsyms1.o
> ld: .tmp_kallsyms1.o: linking constant-gp files with non-constant-gp files
> ld: failed to merge target specific data of file .tmp_kallsyms1.o
> make: *** [vmlinux] Error 1
> 
> which looks like we used the wrong compile options when building
> .tmp_kallsyms1.o

Thanks for testing!

Could you try if this helps.

	Sam

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
