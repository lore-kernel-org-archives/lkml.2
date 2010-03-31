Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0CaHVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:21:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46146 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab0CaHV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:21:28 -0400
Message-ID: <4BB2F7F3.9070100@canonical.com>
Date: Wed, 31 Mar 2010 09:21:23 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org,
       "adel.gadllah@gmail.com" <adel.gadllah@gmail.com>,
       "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
       reinette chatre <reinette.chatre@intel.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] patch iwlwifi-silence-tfds_in_queue-message.patch	added
 to 2.6.32-stable tree
References: <12698953011038@site> <1269900575.2446.3425.camel@rchatre-DESK> <20100329222404.GA10927@suse.de> <4BB1A532.6030502@canonical.com> <20100330200842.GF1693@kroah.com>
In-Reply-To: <20100330200842.GF1693@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------060900000308070408010806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060900000308070408010806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> On Tue, Mar 30, 2010 at 09:16:02AM +0200, Stefan Bader wrote:
>> Greg KH wrote:
>>> On Mon, Mar 29, 2010 at 03:09:35PM -0700, reinette chatre wrote:
>>>> Hi,
>>>>
>>>> On Mon, 2010-03-29 at 13:41 -0700, gregkh@suse.de wrote:
>>>>> This is a note to let you know that we have just queued up the patch titled
>>>>>
>>>>>     Subject: iwlwifi: Silence tfds_in_queue message
>>>>>
>>>>> to the 2.6.32-stable tree.
>>>> [...]
>>>>
>>>> Please note that this patch is really just masking a problem introduced
>>>> by a 2.6.32 backported patch. The real fix is
>>>> https://patchwork.kernel.org/patch/86722/ which should be included in
>>>> 2.6.32.
>>> What is the git commit id for that patch?  patchwork links don't help me
>>> at all.
>> There isn't one. The main problem only exists in 2.6.32.y
>> because the final hunk missed to remove the nfreed++ from
>> ouside the if.
>>
>> Introduced by backport of in 2.6.32.y
>>
>> commit a120e912eb51e347f36c71b60a1d13af74d30e83
>> Author: Stanislaw Gruszka <sgruszka@redhat.com>
>> Date:   Fri Feb 19 15:47:33 2010 -0800
>>
>>     iwlwifi: sanity check before counting number of tfds can be free
> 
> So, what exactly should I be doing here for the .32 stable queue?

git'ified verrsion of patchworks patch attached.

Stefan

> what a mess,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--------------060900000308070408010806
Content-Type: text/x-diff;
 name="0001-pre-stable-iwlwifi-fix-nfreed.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-pre-stable-iwlwifi-fix-nfreed.patch"

>From 5d96faae63f4af4ff4d1effe46d18cc9ba203d00 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 18 Mar 2010 14:29:33 +0000
Subject: [PATCH] iwlwifi: fix nfreed--

During backporting of a120e912eb51e347f36c71b60a1d13af74d30e83
("iwlwifi: sanity check before counting number of tfds can be free")
we forget one hunk, what make lot of messages "free more than
tfds_in_queue" show up in dmesg.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Tested-by: Adel Gadllah <adel.gadllah@gmail.com>
(picked from https://patchwork.kernel.org/patch/86722/)
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index f449f06..cf5ac00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1096,7 +1096,6 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
 
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
-		nfreed++;
 	}
 	return nfreed;
 }
-- 
1.6.3.3


--------------060900000308070408010806--
