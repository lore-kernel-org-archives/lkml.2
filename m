Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0CTIO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 04:14:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50682 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0CTIOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 04:14:54 -0400
Date: Sat, 20 Mar 2010 01:14:44 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: jeremy@goop.org
Subject: 2.6.34-rc2: xen DomU not booting
Message-ID: <alpine.DEB.2.01.1003200058030.5493@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+GQgcWv+NNa2X2o5ccUgbZr2q07yXQSjCA+4f
 WfnoIx0ctqnadJMBsva46IdRRMan2b/QqvgLprKltb1ZpcjcIp
 pTdXjrFGv8EpW8lHq+P6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

again a bit late in the game, I tried to upgrade one of my DomUs from 
2.6.33 to 2.6.34-git (tried -rc1 yesterday, pulled again today, so I'm on 
-rc2 now):

------
dom0# xm create sid.cfg -c
Using config file "/etc/xen/sid.cfg".
Started domain sid

------

Then it just "hangs" there: it won't return to the shellprompt (as if the 
domU crashed) but it won't connect to the domU console either (as it does 
perfectly with 2.6.33). And indeed, the domU is listed as running:

dom0# (xm list sid ; sleep 3; xm list sid) | grep ^sid
sid        55   256     1     r-----    140.8
sid        55   256     1     r-----    144.3

Also, "xm dmesg" is blank and netconsole doesn't work inside a domU, IIRC. 

Hints how to debug this (besides doing git bisect, again) are very much 
welcome!

Oh, the Dom0 is Ubuntu 8.04 (2.6.24-24, Xen 3.2.0) on a Mac Mini.

Thanks,
Christian.
-- 
BOFH excuse #192:

runaway cat on system.
