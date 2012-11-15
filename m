Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2KOHPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:15:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KOHPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:15:17 -0500
Date: Thu, 15 Nov 2012 08:15:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [Q] regulators: 3-current-regulated supply
Message-ID: <Pine.LNX.4.64.1211150749290.684@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:lV0NHB+UbkqPr1OVjlBCFjwSHh2s69xzJ6g6Lt09Y4G
 22TiIWyy28FKNxAmY860GQZpJj+V0gyjRYu3gBKcDnQbRtgAKB
 cVmeWJSJOqMbkONy/ONWNfK9rWUP8qOJ+rm44HV6qi03ZGydGt
 CVlCOmhfmNkA5eVc1ap02jU8Bmi/2Wump6limXzdNjSWaPtNgS
 /NMwyNCrVZGMtA7Ec5yptmUHYR/B/rNaKaLiIAEwrtVF1dyARh
 txW13FBMjOIieUEsFQT/FTZaJzAdXFmOn1o4e47zySCAgeChyX
 L0wjrF6DJ9TrBKFsfFOLMLk3THGJVaBbVkLVr+lZbSRnau/Vem
 5iYDptYG5/Q/YF27bWNz9urvr1LYQQl+uqvH1bK5+yeQ/DxauO
 K/iQPXv1J1E/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm trying to implement a regulator driver for a PMIC [1], and so far I 
don't see how it can be mapped to the present regulator API. Most its 
parts are pretty simple - DCDC step-down, LDO. The first step-up DCDC 
isn't a problem either. It's the second step-up supply, that I'm having a 
problem with. It's output voltage can be regulated by using either a 
voltage feedback or the three current feedbacks. In the current feedback 
mode one has a choice between a manual mode, in which case you just choose 
one of the feedbacks and everything is simple again, or in automatic mode. 
In the automatic mode one can use any subset of the 3 feedbacks. Then the 
PMIC "automatically selects the highest string" (any idea what that means 
anyone?) In any case, that means, that the chip uses some algorithm to 
pick up one of the feedbacks dynamically at run-time, depending on the 
current loads. So, question #1: what should I return from 
.get_current_limit()? I don't think there is a way to find out, which 
current limit is currently being used or how much consumers consume. #2: 
how do I set those 3 limits, resp., what do I do in .set_current_limit()? 
Looks like an API extension is needed...

Thanks
Guennadi

[1] http://www.ams.com/eng/content/download/278923/1044357/AS3711_Datasheet_v1_20.pdf
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
