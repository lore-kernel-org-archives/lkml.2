Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1HXOT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:19:58 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:55277 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210Ab1HXOTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:19:55 -0400
X-AuditID: 1209190c-b7bdeae000000a26-8a-4e55084a9441
From: Andy Lutomirski <luto@MIT.EDU>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH] x86-64: Remove __IGNORE_getcpu
Date: Wed, 24 Aug 2011 10:19:44 -0400
Message-Id: <b4cb60ef45db3a675a0e2b9d51bcb022b0a9ab9c.1314195481.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CAMe9rOrejBbutqRMuE1f5iVn3nr8+zOmFyXgGmn=R9zHMC6U8Q@mail.gmail.com>
References: <CAMe9rOrejBbutqRMuE1f5iVn3nr8+zOmFyXgGmn=R9zHMC6U8Q@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsUixG6nruvFEepnsK7N0KLvylF2i+3rDjNb
	TNsobnF51xw2BxaPnbPusnt83iTncaLlC2sAcxSXTUpqTmZZapG+XQJXxpGHxQW/2Csmb33F
	1MB4ha2LkZNDQsBE4sXWVlYIW0ziwr31QHEuDiGBfYwSm04vYAdJCAlsYJT4s9scIvGMSWLj
	uS6wDjYBFYmOpQ+YQGwRAWWJu1dPg9nMAkUSi3omMYPYwgL6Ei+OfgOzWQRUJea++skCYvMK
	BElsev+VCWKznMSRy8/BbE6BQImWEytZIRYHSEx9f5JxAiPfAkaGVYyyKblVurmJmTnFqcm6
	xcmJeXmpRbqGermZJXqpKaWbGEGBxCnJs4PxzUGlQ4wCHIxKPLw3LgT7CbEmlhVX5h5ilORg
	UhLlTWIP9RPiS8pPqcxILM6ILyrNSS0+xCjBwawkwnvqXIifEG9KYmVValE+TEqag0VJnPfg
	Dgc/IYH0xJLU7NTUgtQimKwMB4eSBG8uyFDBotT01Iq0zJwShDQTByfIcB6g4Y/ZgGp4iwsS
	c4sz0yHypxgVpcR5K0GaBUASGaV5cL2wSH/FKA70ijDvXJAqHmCSgOt+BTSYCWgwx68gkMEl
	iQgpqQZGQcHpu+M25DycqT5BKsbp5zveG4432ysMQ7pPSvQFm1nPWyHJd07jerPXY/WLjIcY
	75YkMenN3LYlOM7i9D5L7jc+skWcaS8X385gZT0wz6VC82tRv19ekMUfvsuL1aQe7H9nIr80
	+8lF7q137lyVK5Pbttr6zMF44aznzSpby8Q2SOQ6vzyoxFKckWioxVxUnAgACbhNus8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change:

commit fce8dc06423d6fb2709469dc5c55b04e09c1d126
Author: Andy Lutomirski <luto@mit.edu>
Date:   Wed Aug 10 11:15:31 2011 -0400

    x86-64: Wire up getcpu syscall

added getcpu as a real syscall, so we shouldn't ignore it any more.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Reported-by: H.J. Lu <hjl.tools@gmail.com>
---

My bad.

 arch/x86/include/asm/unistd_64.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index d92641c..940d720 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -624,7 +624,6 @@ __SYSCALL(__NR_vmsplice, sys_vmsplice)
 __SYSCALL(__NR_move_pages, sys_move_pages)
 #define __NR_utimensat				280
 __SYSCALL(__NR_utimensat, sys_utimensat)
-#define __IGNORE_getcpu		/* implemented as a vsyscall */
 #define __NR_epoll_pwait			281
 __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 #define __NR_signalfd				282
-- 
1.7.6

