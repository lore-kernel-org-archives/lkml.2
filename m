Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3AET34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 14:29:56 -0500
Received: from toccata.ens-lyon.org ([140.77.166.68]:57803 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3AET3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 14:29:52 -0500
Date: Sat, 5 Jan 2013 20:29:44 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>, gregkh@linuxfoundation.org
Cc: William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org,
        speakup@braille.uwo.ca
Subject: Re: [PATCH] drivers/staging/speakup: avoid out-of-range access
Message-ID: <20130105192944.GL5965@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	gregkh@linuxfoundation.org, William Hubbs <w.d.hubbs@gmail.com>,
	Chris Brannon <chris@the-brannons.com>,
	Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org,
	speakup@braille.uwo.ca
References: <1357413465-42357-1-git-send-email-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357413465-42357-1-git-send-email-nickolai@csail.mit.edu>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed. The same happens in synth_add, so Greg please use this instead:


Check that array index is in-bounds before accessing the synths[] array.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---
 drivers/staging/speakup/synth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index df95337..b91d22b 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -342,7 +342,7 @@ int synth_init(char *synth_name)
 
 	mutex_lock(&spk_mutex);
 	/* First, check if we already have it loaded. */
-	for (i = 0; synths[i] != NULL && i < MAXSYNTHS; i++)
+	for (i = 0; i < MAXSYNTHS && synths[i] != NULL; i++)
 		if (strcmp(synths[i]->name, synth_name) == 0)
 			synth = synths[i];
 
@@ -423,7 +423,7 @@ int synth_add(struct spk_synth *in_synth
 	int i;
 	int status = 0;
 	mutex_lock(&spk_mutex);
-	for (i = 0; synths[i] != NULL && i < MAXSYNTHS; i++)
+	for (i = 0; i < MAXSYNTHS && synths[i] != NULL; i++)
 		/* synth_remove() is responsible for rotating the array down */
 		if (in_synth == synths[i]) {
 			mutex_unlock(&spk_mutex);
