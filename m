Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0ERJDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 05:03:09 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:45768 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab0ERJDE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 05:03:04 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Steven Liu <lingjiujianke@gmail.com>,
       Jesper Nilsson <Jesper.Nilsson@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-cris-kernel <linux-cris-kernel@axis.com>,
       "liuqi@thunderst.com" <liuqi@thunderst.com>
Date: Tue, 18 May 2010 11:02:52 +0200
Subject: RE: [PATCH] cris:Check kmalloc return value before use data
Thread-Topic: [PATCH] cris:Check kmalloc return value before use data
Thread-Index: Acr2YoxG304aN4OPTfCkfsdpmCNuFAABil5w
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D0549647A169D@xmail3.se.axis.com>
References: <AANLkTiknP0na-SILHs9Zg3HzgC7XuDx4x0J8fK6RoDE4@mail.gmail.com>
In-Reply-To: <AANLkTiknP0na-SILHs9Zg3HzgC7XuDx4x0J8fK6RoDE4@mail.gmail.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, if you feel like its worth it. If we can't allocate one page of data in an init function we are probably up for more problems soon...

Signed-off-by: Mikael Starvik <starvik@axis.com> 

-----Original Message-----
From: Steven Liu [mailto:lingjiujianke@gmail.com] 
Sent: den 18 maj 2010 08:26
To: Mikael Starvik; Jesper Nilsson; linux-kernel@vger.kernel.org; linux-cris-kernel; liuqi@thunderst.com
Subject: [PATCH] cris:Check kmalloc return value before use data

Check kmalloc return value before use data

Signed-off-by: Liu Qi <lingjiujianke@gmail.com>
---
 arch/cris/arch-v32/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/signal.c
b/arch/cris/arch-v32/kernel/signal.c
index 0b7e3f1..dd69fb4 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -656,6 +656,9 @@ int __init
 cris_init_signal(void)
 {
    u16* data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+   if(!data){
+       printk(KERN_ERR "kmalloc memory failed in %s \n", __func__);
+       return -ENOMEM;
+   }

    /* This is movu.w __NR_sigreturn, r9; break 13; */
    data[0] = 0x9c5f;
--
1.7.1
