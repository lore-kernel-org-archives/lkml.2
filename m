Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0EYJvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:51:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49513 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab0EYJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=W3tEfKBbaIPsQcI7rNJnD2DSsJFN8ALEiuRWVyloVQ6OpCBLhp6U7oSJG0DyVH1Iwo
         HVXdHHUhvDSE4j6IoNYtQ056v1K2WA+siLDEXNcK5u2VSqo/An5brWVKZl6Nq2wmovYp
         aZRE2cDxJ+C5IrlMJwkIAHSu4X5P9PthFVrqg=
Date: Tue, 25 May 2010 11:51:10 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] kobject: free memory if netlink_kernel_create() fails
Message-ID: <20100525095110.GG22515@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a kfree(ue_sk) missing on the error path if 
netlink_kernel_create() fails.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 59c1551..08e15f7 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -378,6 +378,7 @@ static int uevent_net_init(struct net *net)
 	if (!ue_sk->sk) {
 		printk(KERN_ERR
 		       "kobject_uevent: unable to create netlink socket!\n");
+		kfree(ue_sk);
 		return -ENODEV;
 	}
 	mutex_lock(&uevent_sock_mutex);
