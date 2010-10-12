Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0JLAxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:53:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42661 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab0JLAxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:53:36 -0400
Date: Tue, 12 Oct 2010 11:53:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Weber <weber@corscience.de>, Samuel Ortiz <samuel@sortiz.org>
Subject: linux-next: manual merge of the trivial tree with the net tree
Message-Id: <20101012115331.cc88eb1a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
net/irda/irnet/irnet_ppp.c between commit
f8cba16cad68c9b9ee7fecae48a1b91708e8e482 ("irda: Remove BKL instances
from irnet") from the net tree and commit
b42e17963c20ecb80905083ceaecc79fd9bd30f1 ("Fix typo configue => configure
in comments") from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/irda/irnet/irnet_ppp.c
index 0993bd4,36f43ca..0000000
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@@ -664,10 -663,8 +664,10 @@@ dev_irnet_ioctl
        if((val == N_SYNC_PPP) || (val == N_PPP))
  	{
  	  DEBUG(FS_INFO, "Entering PPP discipline.\n");
- 	  /* PPP channel setup (ap->chan in configued in dev_irnet_open())*/
+ 	  /* PPP channel setup (ap->chan in configured in dev_irnet_open())*/
 -	  lock_kernel();
 +	  if (mutex_lock_interruptible(&ap->lock))
 +		  return -EINTR;
 +
  	  err = ppp_register_channel(&ap->chan);
  	  if(err == 0)
  	    {
