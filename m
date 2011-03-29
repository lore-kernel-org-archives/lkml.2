Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1C2O44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:56:56 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:34933 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab1C2O4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:56:54 -0400
Date: Tue, 29 Mar 2011 16:56:51 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Subject: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758
Message-ID: <20110329145651.GA1641@gentoo.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just came across this WARNING (running latest git kernel):

Mar 29 09:14:39 gentoo kernel: udev[888]: starting version 164                                                                                       
Mar 29 15:45:45 gentoo kernel: ------------[ cut here ]------------                                                                                  
Mar 29 15:45:45 gentoo kernel: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 ttm_put_pages+0x1c6/0x2b0()                                      
Mar 29 15:45:45 gentoo kernel: Hardware name: System Product Name                                                                                    
Mar 29 15:45:45 gentoo kernel: Pid: 688, comm: kworker/u:6 Not tainted 2.6.38-09065-g89078d5 #23                                                     
Mar 29 15:45:45 gentoo kernel: Call Trace:                                                                                                           
Mar 29 15:45:45 gentoo kernel: [<ffffffff81073fea>] warn_slowpath_common+0x7a/0xb0                                                                   
Mar 29 15:45:45 gentoo kernel: [<ffffffff8107410a>] warn_slowpath_null+0x1a/0x20                                                                     
Mar 29 15:45:45 gentoo kernel: [<ffffffff8130fe46>] ttm_put_pages+0x1c6/0x2b0                                                                        
Mar 29 15:45:45 gentoo kernel: [<ffffffff8130889d>] ttm_tt_free_alloced_pages+0xbd/0x100                                                             
Mar 29 15:45:45 gentoo kernel: [<ffffffff8130933c>] ttm_tt_swapout+0x1ac/0x2a0                                                                       
Mar 29 15:45:45 gentoo kernel: [<ffffffff8130ab85>] ttm_bo_swapout+0x1a5/0x230                                                                       
Mar 29 15:45:45 gentoo kernel: [<ffffffff812fcefc>] ? drm_mm_kmalloc+0x3c/0xd0                                                                       
Mar 29 15:45:45 gentoo kernel: [<ffffffff81307d38>] ttm_shrink+0xd8/0x120                                                                            
Mar 29 15:45:45 gentoo kernel: [<ffffffff8108f101>] ? queue_delayed_work_on+0x91/0x100                                                               
Mar 29 15:45:45 gentoo kernel: [<ffffffff81307d80>] ? ttm_shrink+0x120/0x120                                                                         
Mar 29 15:45:45 gentoo kernel: [<ffffffff81307d99>] ttm_shrink_work+0x19/0x20                                                                        
Mar 29 15:45:45 gentoo kernel: [<ffffffff8108e0ae>] process_one_work+0x11e/0x4c0                                                                     
Mar 29 15:45:45 gentoo kernel: [<ffffffff8108ea2e>] worker_thread+0x15e/0x340                                                                        
Mar 29 15:45:45 gentoo kernel: [<ffffffff8108e8d0>] ? manage_workers.isra.28+0x220/0x220                                                             
Mar 29 15:45:45 gentoo kernel: [<ffffffff8109348c>] kthread+0x8c/0xa0                                                                                
Mar 29 15:45:45 gentoo kernel: [<ffffffff8156e814>] kernel_thread_helper+0x4/0x10                                                                    
Mar 29 15:45:45 gentoo kernel: [<ffffffff81093400>] ? kthread_flush_work_fn+0x20/0x20                                                                
Mar 29 15:45:45 gentoo kernel: [<ffffffff8156e810>] ? gs_change+0xb/0xb                                                                              
Mar 29 15:45:45 gentoo kernel: ---[ end trace d5b07e4231e70291 ]---                                                                                  
Mar 29 15:45:45 gentoo kernel: ------------[ cut here ]------------
...
It's repeated ad nauseam from there on. (/var/log/kern.log is now over
85MB in size)

-- 
Markus
