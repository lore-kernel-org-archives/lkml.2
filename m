Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1I1WiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1I1WiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:25 2011
Message-Id: <20110928220125.768720706@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [005/244] ASoC: soc-jack: Fix checking return value of request_any_context_irq
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit d2b4c7bd7eabfaa2e3e5b8107d5eeb56ac879813 upstream.

request_any_context_irq() returns a negative value on failure.
On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/soc-jack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -327,7 +327,7 @@ int snd_soc_jack_add_gpios(struct snd_so
 					      IRQF_TRIGGER_FALLING,
 					      gpios[i].name,
 					      &gpios[i]);
-		if (ret)
+		if (ret < 0)
 			goto err;
 
 		if (gpios[i].wake) {


