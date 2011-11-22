Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab1KVV3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:29:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46242 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab1KVV3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:29:16 -0500
Subject: Re: [PATCH v3 00/16] DocG3 fixes and write support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 22 Nov 2011 23:29:08 +0200
In-Reply-To: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
References: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1321997351.2222.14.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-19 at 16:02 +0100, Robert Jarzmik wrote:
> Hi Artem and David,
> 
> This patchset has been in review for several weeks. All
> pending comments have been handled. I'd like to have it in
> for the next merge window. Do I need to do anything else to
> have it integrated (grouping patches to have lesser kernel
> history impact, ...) ?

Hi, pushed to l2-mtd-2.6.git, thanks!

1. The reviewers did not give you any "Reviewed-by:" ?

2. This series has one checkpatch.pl complaint in patch 15, which looks
fair:

ERROR: do not initialise statics to 0 or NULL
#74: FILE: drivers/mtd/devices/docg3.c:64:
+static unsigned int reliable_mode = 0;

total: 1 errors, 0 warnings, 206 lines checked

/home/dedekind/tmp/j15.mbox has style problems, please review.

3. When I compile with gcc-4.6 for x68_64 I see the following
compilation warnings:

  CC [M]  drivers/mtd/devices/docg3.o
drivers/mtd/devices/docg3.c: In function ‘doc_read_oob’:
drivers/mtd/devices/docg3.c:630:3: warning: passing argument 2 of ‘doc_get_hw_bch_syndroms’ from incompatible pointer type [enabled by default]
drivers/mtd/devices/docg3.c:513:13: note: expected ‘int *’ but argument is of type ‘u8 *’
drivers/mtd/devices/docg3.c: At top level:
drivers/mtd/devices/docg3.c:762:12: warning: ‘doc_get_erase_count’ defined but not used [-Wunused-function]

4. sparse gives the following warning:

  CHECK   drivers/mtd/devices/docg3.c
drivers/mtd/devices/docg3.c:630:48: warning: incorrect type in argument 2 (different type sizes)
drivers/mtd/devices/docg3.c:630:48:    expected int *syns
drivers/mtd/devices/docg3.c:630:48:    got unsigned char *<noident>

Could you please look at 2, 3, and 4? I did not look whether they are
fair or not. Please, do not re-send the series again, I think it is OK
if you send incremental fixes instead. Or if you at some point re-send
v4, you can incorporate the warnings fixes, but please, do not send 16
patches again only because of this :-)

Thanks!

