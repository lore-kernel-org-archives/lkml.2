Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1BCNNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 08:13:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33868 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab1BCNNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 08:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NvMQApEhc4optJfYLIyokjoQ8MwLO9bjIMCPAPhEbCTYIOHu37Kv1OHlqnaFmZe0hT
         IHxtsk21sZhVpYK/S8xjKjF6cmeLIO0EsOwUMudXhCu9oV+PsMntssSk2EJMgpnvBKwF
         qlda1eZGQUUpmWZ49uuLN8KHPM7v3v6Tr5wVI=
Date: Thu, 3 Feb 2011 15:13:34 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Tejun Heo <tj@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix section mismatch in reference from native_play_dead
Message-ID: <20110203131333.GA4161@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 

WARNING: arch/x86/kernel/built-in.o(.text+0x19cde): Section mismatch in reference from 
the function native_play_dead() to the function .cpuinit.text:mwait_usable()
The function native_play_dead() references the function __cpuinit mwait_usable().


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0cbe8c0..0b8c6c9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1467,7 +1467,7 @@ static inline void hlt_play_dead(void)
 	}
 }
 
-void native_play_dead(void)
+void __cpuinit native_play_dead(void)
 {
 	play_dead_common();
 	tboot_shutdown(TB_SHUTDOWN_WFS);

