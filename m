Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0C1LsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:48:20 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54303 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0C1LsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:48:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=FvcMMepW+k0EGOLiyvQUvETwH3c9UZfbH+odPGe1GIRA6WqL3b6fk2+1xHos/cbeBa
         38igcLdd6LGiIIuSRkSvfX8usdQBMjznplcIBBIFA+gfdXQiNIRqSBqVdOE7HdjBJVFJ
         wBnwnp9WSdN7VfVeicPaGENMP0AkWu08TfthI=
Date: Sun, 28 Mar 2010 14:48:10 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] hpani: using the wrong variable
Message-ID: <20100328114810.GS5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're updating the "HpPriv->ani" array here so we should use that to
determine the end of the for loop.  "HpPriv->ani" has 50 elements and 
"wd->regulationTable.allowChannel" has 59 elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/otus/hal/hpani.c b/drivers/staging/otus/hal/hpani.c
index 0afecd8..d401504 100644
--- a/drivers/staging/otus/hal/hpani.c
+++ b/drivers/staging/otus/hal/hpani.c
@@ -96,7 +96,7 @@ void zfHpAniAttach(zdev_t* dev)
     HpPriv->hasHwPhyCounters = 1;
 
     memset((char *)&HpPriv->ani, 0, sizeof(HpPriv->ani));
-    for (i = 0; i < N(wd->regulationTable.allowChannel); i++)
+    for (i = 0; i < ARRAY_SIZE(HpPriv->ani); i++)
     {
         /* New ANI stuff */
         HpPriv->ani[i].ofdmTrigHigh = ZM_HAL_ANI_OFDM_TRIG_HIGH;
