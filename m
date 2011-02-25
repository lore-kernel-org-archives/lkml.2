Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab1BYWOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:14:42 -0500
Received: from mail.nec-labs.com ([138.15.200.209]:51371 "EHLO
	mail.nec-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab1BYWOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:14:41 -0500
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Feb 2011 17:14:41 EST
Message-ID: <4D6824A4.6030009@nec-labs.com>
Date: Fri, 25 Feb 2011 16:52:36 -0500
From: Steve Rago <sar@nec-labs.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Allow O_SYNC to be set by fcntl(F_SETFL)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has probably been a problem since day 1 (I ran into this running the 2.4 kernel years ago; finally got around to 
fixing it).  The problem is that fcntl(fd, F_SETFL, flags|O_SYNC) appears to work, but silently ignores the O_SYNC flag. 
  Opening the file with O_SYNC works okay, but setting it later on via fcntl doesn't work.


Signed-off-by: Steve Rago <sar@nec-labs.com>
---
  fs/fcntl.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index cb10261..afd233a 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -143,7 +143,7 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
         return ret;
  }

-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME | O_SYNC)

  static int setfl(int fd, struct file * filp, unsigned long arg)
  {
--
1.7.2.1

