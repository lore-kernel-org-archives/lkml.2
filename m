Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280Ab2EJRdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:33:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52483 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760206Ab2EJRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:48 -0400
Message-Id: <20120510173133.664541718@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Zhao <richard.zhao@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 08/52] ASoC: core: check of_property_count_strings failure
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhao <richard.zhao@freescale.com>

commit c34ce320d9fe328e3272def20b152f39ccfa045e upstream.

Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3420,10 +3420,10 @@ int snd_soc_of_parse_audio_routing(struc
 	int i, ret;
 
 	num_routes = of_property_count_strings(np, propname);
-	if (num_routes & 1) {
+	if (num_routes < 0 || num_routes & 1) {
 		dev_err(card->dev,
-			"Property '%s's length is not even\n",
-			propname);
+		     "Property '%s' does not exist or its length is not even\n",
+		     propname);
 		return -EINVAL;
 	}
 	num_routes /= 2;


