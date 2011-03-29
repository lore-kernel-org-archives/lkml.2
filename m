Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1C2QbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:31:14 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34384 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1C2QbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:31:12 -0400
Date: Tue, 29 Mar 2011 18:31:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac last minute fix
Message-ID: <20110329163105.GD22419@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this last-minute amd64_edac fix for a potential memleak if
it's not too late yet. If it is, I'll send it to you after -rc1 is out
since it is a minor bugfix.

Thanks.

The following changes since commit 89078d572eb9ce8d4c04264b8b0ba86de0d74c8f:

  md: Fix integrity registration error when no devices are capable (2011-03-28 17:53:29 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (1):
      amd64_edac: Fix potential memleak

 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--

commit a9f0fbe2bbf328f869fc5ee5a12c6a4118c32689
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Tue Mar 29 18:10:53 2011 +0200

    amd64_edac: Fix potential memleak
    
    We check the pointers together but at least one of them could be invalid
    due to failed allocation. Since we cannot continue if either of the two
    allocations has failed, exit early by freeing them both.
    
    Cc: <stable@kernel.org> # 38.x
    Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 0be30e9..31e71c4f 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2679,7 +2679,7 @@ static int __init amd64_edac_init(void)
 	mcis	  = kzalloc(amd_nb_num() * sizeof(mcis[0]), GFP_KERNEL);
 	ecc_stngs = kzalloc(amd_nb_num() * sizeof(ecc_stngs[0]), GFP_KERNEL);
 	if (!(mcis && ecc_stngs))
-		goto err_ret;
+		goto err_free;
 
 	msrs = msrs_alloc();
 	if (!msrs)
-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
