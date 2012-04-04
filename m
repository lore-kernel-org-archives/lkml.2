Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab2DDOGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:06:11 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48500 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab2DDOGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:06:09 -0400
Date: Wed, 4 Apr 2012 16:05:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] One MCE decoding fixlet for 3.4
Message-ID: <20120404140559.GA20746@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following fixlet for -rc2.

Thanks.

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/mce-fix-for-3.4

for you to fetch changes up to ec3e82d6dc46cac7309b01ff9761f469b0263019:

  MCE, AMD: Drop too granulary family model checks (2012-04-04 15:50:11 +0200)

----------------------------------------------------------------
One fix which makes MCE decoding much more "liberal" wrt families.

----------------------------------------------------------------
Borislav Petkov (1):
      MCE, AMD: Drop too granulary family model checks

 drivers/edac/mce_amd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

commit ec3e82d6dc46cac7309b01ff9761f469b0263019
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Wed Apr 4 14:21:02 2012 +0200

    MCE, AMD: Drop too granulary family model checks
    
    MCA details seldom change inbetween the models of a family so don't
    be too conservative and enable decoding on everything starting from
    K8 onwards. Minor adjustments can come in later but most importantly,
    we have some decoding infrastructure in place for upcoming models by
    default.
    
    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 36e1486eb9aa..d0c372e30de4 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -754,9 +754,7 @@ static int __init mce_amd_init(void)
 	if (c->x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	if ((c->x86 < 0xf || c->x86 > 0x12) &&
-	    (c->x86 != 0x14 || c->x86_model > 0xf) &&
-	    (c->x86 != 0x15 || c->x86_model > 0xf))
+	if (c->x86 < 0xf || c->x86 > 0x15)
 		return 0;
 
 	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
@@ -797,7 +795,7 @@ static int __init mce_amd_init(void)
 		break;
 
 	default:
-		printk(KERN_WARNING "Huh? What family is that: %d?!\n", c->x86);
+		printk(KERN_WARNING "Huh? What family is it: 0x%x?!\n", c->x86);
 		kfree(fam_ops);
 		return -EINVAL;
 	}
-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
