Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab1IUFB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:01:28 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:39771 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1IUFB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:01:27 -0400
Date: Wed, 21 Sep 2011 15:01:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hector Martin <hector@marcansoft.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        Andre Heider <a.heider@gmail.com>, Geoff Levand <geoff@infradead.org>
Subject: linux-next: manual merge of the tty tree with the powerpc tree
Message-Id: <20110921150121.9f530384bc0bb6c2268fd9ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the tty tree got conflicts in
arch/powerpc/include/asm/udbg.h and arch/powerpc/kernel/udbg.c between
commit c26afe9e8591 ("powerpc/ps3: Add gelic udbg driver") from the
powerpc tree and commit dcd83aaff1c8 ("tty/powerpc: introduce the ePAPR
embedded hypervisor byte channel driver") from the tty tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/include/asm/udbg.h
index 6587ec7,5354ae9..0000000
--- a/arch/powerpc/include/asm/udbg.h
+++ b/arch/powerpc/include/asm/udbg.h
@@@ -54,9 -54,7 +54,10 @@@ extern void __init udbg_init_40x_realmo
  extern void __init udbg_init_cpm(void);
  extern void __init udbg_init_usbgecko(void);
  extern void __init udbg_init_wsp(void);
 +extern void __init udbg_init_ps3gelic(void);
 +extern void __init udbg_init_debug_opal_raw(void);
 +extern void __init udbg_init_debug_opal_hvsi(void);
+ extern void __init udbg_init_ehv_bc(void);
  
  #endif /* __KERNEL__ */
  #endif /* _ASM_POWERPC_UDBG_H */
diff --cc arch/powerpc/kernel/udbg.c
index 35f9482,b4607a9..0000000
--- a/arch/powerpc/kernel/udbg.c
+++ b/arch/powerpc/kernel/udbg.c
@@@ -67,12 -67,8 +67,14 @@@ void __init udbg_early_init(void
  	udbg_init_usbgecko();
  #elif defined(CONFIG_PPC_EARLY_DEBUG_WSP)
  	udbg_init_wsp();
 +#elif defined(CONFIG_PPC_EARLY_DEBUG_PS3GELIC)
 +	udbg_init_ps3gelic();
 +#elif defined(CONFIG_PPC_EARLY_DEBUG_OPAL_RAW)
 +	udbg_init_debug_opal_raw();
 +#elif defined(CONFIG_PPC_EARLY_DEBUG_OPAL_HVSI)
 +	udbg_init_debug_opal_hvsi();
+ #elif defined(CONFIG_PPC_EARLY_DEBUG_EHV_BC)
+ 	udbg_init_ehv_bc();
  #endif
  
  #ifdef CONFIG_PPC_EARLY_DEBUG
