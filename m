Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0CVMHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:07:42 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54608 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0CVMHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=gkLWpCMpwdEGKgoeeXkIGMyWEoL3HWYQEt5h/F14tnI4XuKo4D6Nl1J9WOG9adF0RL
         XxtyK4d4BGhJnQqQeK99v/+Z8RWMpd75FKm8eKjTzbijA7vedIr+tlz8qgnSi66oyMKn
         bKUFec5u6xo9Si8wFWMN97CLYOmQr0kyqKrOc=
Date: Mon, 22 Mar 2010 15:07:28 +0300
From: Dan Carpenter <error27@gmail.com>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>, Jiri Pirko <jpirko@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch] ewrk3: range checking problem
Message-ID: <20100322120728.GD21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>,
	Patrick McHardy <kaber@trash.net>, Jiri Pirko <jpirko@redhat.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The range checking here is wrong.  It should be HASH_TABLE_LEN which 
is 512.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/ewrk3.c b/drivers/net/ewrk3.c
index 91e59f3..ae02de1 100644
--- a/drivers/net/ewrk3.c
+++ b/drivers/net/ewrk3.c
@@ -1776,8 +1776,7 @@ static int ewrk3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		break;
 	case EWRK3_SET_MCA:	/* Set a multicast address */
 		if (capable(CAP_NET_ADMIN)) {
-			if (ioc->len > 1024)
-			{
+			if (ioc->len > HASH_TABLE_LEN) {
 				status = -EINVAL;
 				break;
 			}
