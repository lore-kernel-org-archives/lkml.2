Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab2ESMEF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 08:04:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab2ESMEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 08:04:02 -0400
Message-ID: <4FB78C28.2040009@redhat.com>
Date: Sat, 19 May 2012 09:03:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org,
        thayne.l.h@gmail.com
Subject: Re: linux-next: Tree for May 18 (edac)
References: <20120518184943.2c762e8441e53ea24748d1b8@canb.auug.org.au> <4FB70267.9030702@xenotime.net>
In-Reply-To: <4FB70267.9030702@xenotime.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-05-2012 23:16, Randy Dunlap escreveu:
> On 05/18/2012 01:49 AM, Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Changes since 201205017:
> 
> 
> 
> on i386:
> 
> lots of build errors for the attached randconfig file.
> 
Sorry, this was due to a bad rebase conflict at the edac tree:
	https://lkml.org/lkml/2012/5/18/321

changeset 90b40d5cadba20d7fe2fce12d61f97e0870c1ba6 should be, instead:

	http://git.infradead.org/users/mchehab/edac.git/commit/d24e447c14c328d0285317e916a0012c73df0d0b

Just updated the tree with the fixed patch merged with
the broken one.

Anyway, the fix patch is enclosed.

Regards,
Mauro

-

edac: Fix compilation breakage on amd76x_edac and i82875p

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index c974da7..a015fba 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -251,7 +251,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = 1;
 	layers[1].is_virt_csrow = false;
-	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), 0);
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, 0);
 
 	if (mci == NULL)
 		return -ENOMEM;
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index ae15359..db64bd7 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -420,6 +420,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	layers[1].size = nr_chans;
 	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(*pvt));
+	if (!mci) {
 		rc = -ENOMEM;
 		goto fail0;
 	}
