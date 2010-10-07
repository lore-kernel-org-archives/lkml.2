Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112Ab0JGDxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:53:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34441 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760005Ab0JGDxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:53:13 -0400
Date: Thu, 7 Oct 2010 14:53:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@linux.ie>
Subject: linux-next: manual merge of the bkl-llseek tree with the drm tree
Message-Id: <20101007145309.0fb5dbe6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-llseek tree got a conflict in
drivers/gpu/drm/vmwgfx/vmwgfx_drv.c between commit
7fbd721ad35f8ffec8d9a82e0e4b390cb6c9f4f7 ("drm/vmwgfx: Add new-style PM
hooks to improve hibernation behavior") from the drm tree and commit
dc880abef75e7c62c9048171f5112500f36a9244 ("drm: use noop_llseek") from
the bkl-llseek tree.

Just a trivial whitepsace change.  I fixed it up (see below) and can
carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index f2942b3,d237190..0000000
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@@ -899,16 -745,16 +899,17 @@@ static struct drm_driver driver = 
  #if defined(CONFIG_COMPAT)
  		 .compat_ioctl = drm_compat_ioctl,
  #endif
+ 		 .llseek = noop_llseek,
 -		 },
 +	},
  	.pci_driver = {
 -		       .name = VMWGFX_DRIVER_NAME,
 -		       .id_table = vmw_pci_id_list,
 -		       .probe = vmw_probe,
 -		       .remove = vmw_remove,
 -		       .suspend = vmw_pci_suspend,
 -		       .resume = vmw_pci_resume
 -		       },
 +		 .name = VMWGFX_DRIVER_NAME,
 +		 .id_table = vmw_pci_id_list,
 +		 .probe = vmw_probe,
 +		 .remove = vmw_remove,
 +		 .driver = {
 +			 .pm = &vmw_pm_ops
 +		 }
 +	 },
  	.name = VMWGFX_DRIVER_NAME,
  	.desc = VMWGFX_DRIVER_DESC,
  	.date = VMWGFX_DRIVER_DATE,
