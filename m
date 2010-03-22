Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0CVMEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:04:08 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47781 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab0CVMEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:04:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=eb1nJUi04rf+lofdvDhzymnL3tCk972dmLgzzd+i2kiKABCwhhQlR4gP9YoPuf711c
         IJ9l6xvqsAHzXqreDkWVTJAihOYUANtEbxXpH0TDODkpLKR28Lk5RM2hfBy+as26gYjI
         CvxaGzkjTehzt/egksJFH6v6i1mUiYr+mUfjo=
Date: Mon, 22 Mar 2010 15:03:54 +0300
From: Dan Carpenter <error27@gmail.com>
To: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] dlm: cleanup remove unused code
Message-ID: <20100322120354.GB21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Christine Caulfield <ccaulfie@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains because "lkb" is never NULL.  Looking at it, the original
code actually adds the new element to the end of the list fine, so we can
just get rid of the if condition.  This code is four years old and no one
has complained so it must work.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 46ffd3e..f162de5 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -732,10 +732,7 @@ static void lkb_add_ordered(struct list_head *new, struct list_head *head,
 		if (lkb->lkb_rqmode < mode)
 			break;
 
-	if (!lkb)
-		list_add_tail(new, head);
-	else
-		__list_add(new, lkb->lkb_statequeue.prev, &lkb->lkb_statequeue);
+	__list_add(new, lkb->lkb_statequeue.prev, &lkb->lkb_statequeue);
 }
 
 /* add/remove lkb to rsb's grant/convert/wait queue */
