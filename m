Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1IODO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 23:14:57 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44757 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1IODO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 23:14:56 -0400
Date: Thu, 15 Sep 2011 13:14:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110915131453.7ce8c4e9d6d1bcd7f8ade995@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/rt2x00/rt2800usb.c between commit 674db1344443
("rt2x00: fix crash in rt2800usb_get_txwi") from Linus' tree and commit
31937c423ed3 ("rt2x00: Minor optimizazion in txdone path") from the
wireless tree.

I fixed it up (see below) anc can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/rt2x00/rt2800usb.c
index dbf501c,4b907a5..0000000
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@@ -538,11 -529,13 +538,12 @@@ static void rt2800usb_txdone(struct rt2
  			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
  			if (rt2800usb_txdone_entry_check(entry, reg))
  				break;
 +			entry = NULL;
  		}
  
 -		if (!entry || rt2x00queue_empty(queue))
 -			break;
 -
 -		rt2800_txdone_entry(entry, reg,
 +		if (entry)
- 			rt2800_txdone_entry(entry, reg);
++			rt2800_txdone_entry(entry, reg,
+ 				    rt2800usb_get_txwi(entry));
  	}
  }
  
