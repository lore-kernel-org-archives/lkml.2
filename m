Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2HaNSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:18:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35336 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2HaNST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:19 -0400
Message-ID: <5040B80E.4070809@gmail.com>
Date: Fri, 31 Aug 2012 15:11:42 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] um: fix compilation error
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a compilation error due to a regression of commit
d3c1cfcdb43e023ab1b1c7a555cd9e929026500a
"um: pass siginfo to guest process".

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
  arch/um/os-Linux/time.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index f602385..0748fe0 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -114,7 +114,7 @@ static void deliver_alarm(void)
  	skew += this_tick - last_tick;

  	while (skew >= one_tick) {
-		alarm_handler(SIGVTALRM, NULL);
+		alarm_handler(SIGVTALRM, NULL, NULL);
  		skew -= one_tick;
  	}

-- 
1.7.3.4
