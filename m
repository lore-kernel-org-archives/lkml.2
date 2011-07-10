Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1GJDXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 23:23:54 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:50353 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330Ab1GJDW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 23:22:26 -0400
X-AuditID: 12074424-b7bc6ae000005a77-b9-4e191af21a83
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 4/8] x86-64: Add --no-undefined to vDSO build
Date: Sat,  9 Jul 2011 23:22:11 -0400
Message-Id: <53c5eba0bbfa12935d2381e77ea1b495b709e0e2.1310267866.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310267866.git.luto@mit.edu>
References: <cover.1310267866.git.luto@mit.edu>
In-Reply-To: <cover.1310267866.git.luto@mit.edu>
References: <cover.1310267866.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsUixCmqrftJStLP4MReXou+K0fZLS42bmOx
	aF07n93i8q45bBZbLjWzWvzY8JjVgc2j+9EnRo9bbX+YPXbOusvusWlVJ5vHuWt9zB6fN8kF
	sEVx2aSk5mSWpRbp2yVwZcx40sBe8JC14s4iqwbGhyxdjJwcEgImEhv+T2KCsMUkLtxbz9bF
	yMUhJLCPUeJPzwtGCGc9o8T39d+hMk+ZJHa96mMFaWETUJHoWPoAqJ2DQ0RASGLp3TqQGmaB
	TYwSvzZNZASpERZwkFg1+RMbiM0ioCqx99pZNpB6XoEgiUuntSE2y0kcufwc7ApOAQOJ5Xdn
	g5ULCehLdH7az45LfAKjwAJGhlWMsim5Vbq5iZk5xanJusXJiXl5qUW65nq5mSV6qSmlmxhB
	wcruorKDsfmQ0iFGAQ5GJR7en8USfkKsiWXFlbmHGCU5mJREeXmBoS7El5SfUpmRWJwRX1Sa
	k1p8iFGCg1lJhLdmE1A5b0piZVVqUT5MSpqDRUmct9T7v6+QQHpiSWp2ampBahFMVoaDQ0mC
	NxBkqGBRanpqRVpmTglCmomDE2Q4D9BwTpAa3uKCxNzizHSI/CtGcaAzhXm5QFI8wASCJCMB
	dK0I7/TnIBcVlyQipKQaGBmXzpo/6ZPngg9rPvmn1x69k7h5fuxixyMZG5bs0w/bsPRhtPHq
	3WevKkjqn47eL174qDn/gNj1Bf5FeuXfw79t7Tm287ywVi2/iKa5yL6j/LN92ln+qKh+n3Lr
	6U37YGOP5In3/1y92r9jcZRb/xKFW8r3vzqZqudfsVjWOl+m+evkgh8PFngpsRRnJBpqMRcV
	JwIAAWDped0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gives much nicer diagnostics when something goes wrong.  It's
supported at least as far back as binutils 2.15.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index bef0bc9..5d17950 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -26,6 +26,7 @@ targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 export CPPFLAGS_vdso.lds += -P -C
 
 VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
+			-Wl,--no-undefined \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
-- 
1.7.6

