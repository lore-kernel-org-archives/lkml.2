Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966344Ab2C3Vcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:32:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53626 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966286Ab2C3Vcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:46 -0400
X-Sasl-enc: o/qNinv7/kHA8aLCB7EOdqm0Un0v/92IStz8NAp1b5uq 1333143165
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:49:00 2012
Message-Id: <20120330194859.940679922@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 168/175] lockd: fix arg parsing for grace_period and timeout.
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
 


