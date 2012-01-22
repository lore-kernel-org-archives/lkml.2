Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2AVNNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 08:13:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47597 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751724Ab2AVNNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 08:13:14 -0500
Content-Type: text/plain; charset="utf-8"
Date: Sun, 22 Jan 2012 14:13:10 +0100
From: "Lars Callenbach" <lars.callenbach@gmx.de>
Message-ID: <20120122131310.191470@gmx.net>
MIME-Version: 1.0
Subject: PROBLEM:  nouveau & ttm module crashes  
To: linux-kernel@vger.kernel.org
X-Authenticated: #7374987
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18FE+8U/R4Fvx1klkMtSq+VKRtLbW6MWbq+RWOKIP
 d9c5NU+NEjCFctrGZQOiKmzWHsN54sXa26ww== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: MW5ub68reSEqX+rrG3QhDUx+IGRvb8DT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have had some problems with nouveau on my box. Loading the module  
crashes Linux 3.2.1 (modprobe hangs with kernel trace). The following two 
code fragments are relevant and should be changed:

1) drivers/gpu/drm/ttm/ttm_bo.c - line 1529
you should comment BUG_ON; this validation will be done two lines later  
in drm_mm_takedown more gracefully. On my box this line is triggered
and results in a hang of modprobe.

2) drivers/gpu/drm/nouveau/nouveau_hw.c - line 1024
dev!=NULL but dev->vblank_enabled == NULL (is not catched and results in
Null pointer reference)

With both changes it is possible to load nouveau without kernel crashes on 
my box. 


Regards, 
   Lars
-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
