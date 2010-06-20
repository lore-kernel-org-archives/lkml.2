Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab0FTUNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:13:15 -0400
Received: from csmtp2.one.com ([91.198.169.22]:43408 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004Ab0FTUNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:13:14 -0400
Message-ID: <4C1E7657.9070606@bitmath.org>
Date: Sun, 20 Jun 2010 22:13:11 +0200
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] Introduce buflock, a one-to-many circular buffer mechanism
 (rev2)
References: <1277060705-3363-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1277060705-3363-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...

diff --git a/include/linux/buflock.h b/include/linux/buflock.h
index 3d5df22..05996d5 100644
--- a/include/linux/buflock.h
+++ b/include/linux/buflock.h
@@ -125,8 +125,8 @@ static inline unsigned int bufwrite_at(const struct buflock_
writer *bw)
  */
 static inline void bufwrite_unlock(struct buflock_writer *bw)
 {
-	++bw->head;
 	smp_wmb();
+	++bw->head;
 }

