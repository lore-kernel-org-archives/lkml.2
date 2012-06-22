Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773Ab2FVA2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:28:15 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13053 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760758Ab2FVA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:28:14 -0400
Date: Fri, 22 Jun 2012 02:28:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6656: Correct a few assignments to be compares
 in iwctl_siwencodeext()
Message-ID: <alpine.LNX.2.00.1206220225000.7671@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The result of "foo = bar" is true, so in statements such as
  ...
  if((pDevice->bwextstep0 = TRUE)&&(param->u.wpa_key.key_index ==1))
  ...
an assignment  is most likely not what was intended - a comparison was. As in:
  ...
  if ((pDevice->bwextstep0 == TRUE) && (param->u.wpa_key.key_index == 1))
  ...

There are a 3 such mistakes in the iwctl_siwencodeext() function.
This patch fixes them all.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

  The file could also do with a serious style cleanup, but that's a 
  different (set of) patches. This one just fixes the bug.

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index b24e531..5740438 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1708,15 +1708,15 @@ if(param->u.wpa_key.alg_name == WPA_ALG_NONE) {
    if(param->u.wpa_key.key_index ==0) {
      pDevice->bwextstep0 = TRUE;
     }
-   if((pDevice->bwextstep0 = TRUE)&&(param->u.wpa_key.key_index ==1)) {
+   if ((pDevice->bwextstep0 == TRUE) && (param->u.wpa_key.key_index == 1)) {
      pDevice->bwextstep0 = FALSE;
      pDevice->bwextstep1 = TRUE;
     }
-   if((pDevice->bwextstep1 = TRUE)&&(param->u.wpa_key.key_index ==2)) {
+   if ((pDevice->bwextstep1 == TRUE) && (param->u.wpa_key.key_index == 2)) {
      pDevice->bwextstep1 = FALSE;
      pDevice->bwextstep2 = TRUE;
 	}
-   if((pDevice->bwextstep2 = TRUE)&&(param->u.wpa_key.key_index ==3)) {
+   if ((pDevice->bwextstep2 == TRUE)&&(param->u.wpa_key.key_index == 3)) {
      pDevice->bwextstep2 = FALSE;
      pDevice->bwextstep3 = TRUE;
         }
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

