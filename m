Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071Ab2HJACg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 20:02:36 -0400
Received: from seven.medozas.de ([5.9.24.206]:37123 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041Ab2HJACf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 20:02:35 -0400
Date: Fri, 10 Aug 2012 02:02:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Michal Marek <mmarek@suse.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Jan Beulich <jbeulich@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "Inconsistent kallsyms data" error
In-Reply-To: <20120707214033.GA5303@pobox.suse.cz>
Message-ID: <alpine.LNX.2.01.1208100202070.4234@frira.zrqbmnf.qr>
References: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com> <20120707214033.GA5303@pobox.suse.cz>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2012-07-07 23:40, Michal Marek wrote:
>index cd9c6c6..4629038 100644
>--- a/scripts/link-vmlinux.sh
>+++ b/scripts/link-vmlinux.sh
>@@ -210,8 +210,8 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
> 	mksysmap ${kallsyms_vmlinux} .tmp_System.map
> 
> 	if ! cmp -s System.map .tmp_System.map; then
>-		echo Inconsistent kallsyms data
>-		echo echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
>+		echo >&2 Inconsistent kallsyms data
>+		echo >&2 echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround

Hm why is there echo twice in that one line? Seems like an oversight..
