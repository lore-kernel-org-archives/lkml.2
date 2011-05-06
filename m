Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1EFSE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:04:57 -0400
Received: from mail.perches.com ([173.55.12.10]:1293 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab1EFSE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:04:56 -0400
Subject: Re: [TRIVIAL PATCH 0/3] pcmcia: Make struct pcmcia_device_id const
From: Joe Perches <joe@perches.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Jiri Kosina <trivial@kernel.org>,
        Linux PCMCIA team <linux-pcmcia@lists.infradead.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110506061527.GA26026@comet.dominikbrodowski.net>
References: <cover.1304475547.git.joe@perches.com>
	 <20110506061527.GA26026@comet.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 11:04:55 -0700
Message-ID: <1304705095.11874.21.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 08:15 +0200, Dominik Brodowski wrote:
> On Tue, May 03, 2011 at 07:28:59PM -0700, Joe Perches wrote:
> > Reduces data use.
> > Staging could be applied now, but additional harmless warnings do result.
> > Joe Perches (3):
> >   pcmcia: Make declaration and uses of struct pcmcia_device_id const
> >   pcmcia: Convert pcmcia_device_id declarations to const
> >   staging: pcmcia: Convert pcmcia_device_id declarations to const
> Thanks, applied all three patches to the pcmcia git tree.

Hi Dominik, just so you're aware...

By the time your tree gets pushed, there'll likely
be conflicts with staging changes.

It might be appropriate to keep the staging patch
separate from the other 2.

There are also a couple of uses of pcmcia_device_id
in sound/ that could be modified.

$ grep -rPwn --include=*.[ch] pcmcia_device_id sound
sound/pcmcia/vx/vxpocket.c:353:static struct pcmcia_device_id vxp_ids[] = {
sound/pcmcia/pdaudiocf/pdaudiocf.c:281:static struct pcmcia_device_id snd_pdacf_ids[] = {

Here's a patch for those as well

---

Make declarations of struct pcmcia_device_id const.

Signed-off-by: Joe Perches <joe@perches.com>

---

 sound/pcmcia/pdaudiocf/pdaudiocf.c |    2 +-
 sound/pcmcia/vx/vxpocket.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf.c b/sound/pcmcia/pdaudiocf/pdaudiocf.c
index 8cc4733..ce33be0 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf.c
@@ -278,7 +278,7 @@ static int pdacf_resume(struct pcmcia_device *link)
 /*
  * Module entry points
  */
-static struct pcmcia_device_id snd_pdacf_ids[] = {
+static const struct pcmcia_device_id snd_pdacf_ids[] = {
 	/* this is too general PCMCIA_DEVICE_MANF_CARD(0x015d, 0x4c45), */
 	PCMCIA_DEVICE_PROD_ID12("Core Sound","PDAudio-CF",0x396d19d2,0x71717b49),
 	PCMCIA_DEVICE_NULL
diff --git a/sound/pcmcia/vx/vxpocket.c b/sound/pcmcia/vx/vxpocket.c
index 80000d6..d9ef21d 100644
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -350,7 +350,7 @@ static void vxpocket_detach(struct pcmcia_device *link)
  * Module entry points
  */
 
-static struct pcmcia_device_id vxp_ids[] = {
+static const struct pcmcia_device_id vxp_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x01f1, 0x0100),
 	PCMCIA_DEVICE_NULL
 };


