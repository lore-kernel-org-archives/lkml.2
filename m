Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935410Ab2C3VIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:08:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55577 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935400Ab2C3VIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:08:47 -0400
Message-Id: <20120330195736.915004184@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:59:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 103/108] lockd: fix arg parsing for grace_period and timeout.
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit de5b8e8e047534aac6bc9803f96e7257436aef9c upstream.

If you try to set grace_period or timeout via a module parameter
to lockd, and do this on a big-endian machine where

   sizeof(int) != sizeof(unsigned long)

it won't work.  This number given will be effectively shifted right
by the difference in those two sizes.

So cast kp->arg properly to get correct result.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/svc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -440,7 +440,7 @@ static int param_set_##name(const char *
 	__typeof__(type) num = which_strtol(val, &endp, 0);		\
 	if (endp == val || *endp || num < (min) || num > (max))		\
 		return -EINVAL;						\
-	*((int *) kp->arg) = num;					\
+	*((type *) kp->arg) = num;					\
 	return 0;							\
 }
 


