Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab1LORZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:25:08 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:46092
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759032Ab1LORZG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:25:06 -0500
X-SpamScore: -25
X-BigFish: VPS-25(zz9371Ic89bh154dM1432N98dKzz1202hzz15d4R8275bhz2dh668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LW99PJ-01-AC1-02
X-M-MSG: 
Date: Thu, 15 Dec 2011 18:24:54 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix compile error in sound/soc/mid-x86/sst_platform.c
Message-ID: <20111215172453.GH2112@amd.com>
References: <20111215165248.GG2112@amd.com>
 <CADZ9YHi4XX4gzPvbqxBndgNGoMMNzdQH9DqjC4fT7bKRpxjcXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CADZ9YHi4XX4gzPvbqxBndgNGoMMNzdQH9DqjC4fT7bKRpxjcXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:16:52PM +0600, Rakib Mullick wrote:
> On Thu, Dec 15, 2011 at 10:52 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > (again with mailing lists on Cc, sorry)
> >
> > Hi,
> >
> > I tested current linux-next against my iommu-configs and found a compile
> > error in sound/soc/mid-x86/sst_platform.c. The variable ret_val in the
> > sst_platform_open() function is used but not declared. Attached patch
> > fixes this.
> >
> 
> While fixing any kind of error/warning, it's nice to have
> error/warning message in changelog.

Okay, here it is:

>From 9d0876632c4fc07254eafbe5018e68963bdcfe17 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 15 Dec 2011 17:39:31 +0100
Subject: [PATCH] Fix compile error in sound/soc/mid-x86/sst_platform.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The variable ret_val is used but not declared. This causes
the following compile error:

sound/soc/mid-x86/sst_platform.c: In function ‘sst_platform_open’:
sound/soc/mid-x86/sst_platform.c:274:2: error: ‘ret_val’ undeclared (first use in this function)
sound/soc/mid-x86/sst_platform.c:274:2: note: each undeclared identifier is reported only once for each function it appears in
make[1]: *** [sound/soc/mid-x86/sst_platform.o] Error 1

Fix this.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 sound/soc/mid-x86/sst_platform.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/mid-x86/sst_platform.c b/sound/soc/mid-x86/sst_platform.c
index 24f9471..11c39c5 100644
--- a/sound/soc/mid-x86/sst_platform.c
+++ b/sound/soc/mid-x86/sst_platform.c
@@ -267,6 +267,7 @@ static int sst_platform_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct sst_runtime_stream *stream;
+	int ret_val;
 
 	pr_debug("sst_platform_open called\n");
 
-- 
1.7.5.4


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

