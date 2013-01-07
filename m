Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab3AGVD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:03:57 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:55930 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab3AGVD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:03:56 -0500
Date: Mon, 7 Jan 2013 22:03:51 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org,
        speakup@braille.uwo.ca
Subject: Re: [PATCH] drivers/staging/speakup: avoid out-of-range access
Message-ID: <20130107210351.GJ5998@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	William Hubbs <w.d.hubbs@gmail.com>,
	Chris Brannon <chris@the-brannons.com>,
	Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org,
	speakup@braille.uwo.ca
References: <1357413465-42357-1-git-send-email-nickolai@csail.mit.edu>
 <20130105192944.GL5965@type.youpi.perso.aquilenet.fr>
 <20130107174453.GA15120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130107174453.GA15120@kroah.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH, le Mon 07 Jan 2013 09:44:53 -0800, a écrit :
> Wait, Nickolai wrote the first patch, so how could he sign off on your
> patch?  How about sending me an add-on patch on top of the first one
> which adds the additional check?

Right, here it is:


Check that array index is in-bounds before accessing the synths[] array.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---
 drivers/staging/speakup/synth.c |    2 +-
 1 file changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index df95337..b91d22b 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -423,7 +423,7 @@ int synth_add(struct spk_synth *in_synth
 	int i;
 	int status = 0;
 	mutex_lock(&spk_mutex);
-	for (i = 0; synths[i] != NULL && i < MAXSYNTHS; i++)
+	for (i = 0; i < MAXSYNTHS && synths[i] != NULL; i++)
 		/* synth_remove() is responsible for rotating the array down */
 		if (in_synth == synths[i]) {
 			mutex_unlock(&spk_mutex);
