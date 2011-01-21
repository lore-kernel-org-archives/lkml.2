Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1AUXHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:07:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46131 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753263Ab1AUXHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:07:17 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+dvrkiHlSdAkAjvlolDQxsM7McESQ3KedY1FXHA4
	JtSJ05NmusfeTt
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com
Subject: make arch code use xtime_update() instead of do_timer() 
Date: Sat, 22 Jan 2011 00:06:46 +0100
Message-Id: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move do_timer() into kernel/time/timekeeping.c
and provide a version which properly takes the xtime_lock()

finally makes do_timer() and xtime_lock into a header file
private to kernel/time

xtime_lock is still used by kernel/hrtimer.c and kernel/time.c
i am not sure, whether the small header file is the right
thing though.



