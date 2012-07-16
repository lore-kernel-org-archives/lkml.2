Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2GPTpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:45:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2GPTpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:45:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH V2 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Mon, 16 Jul 2012 16:22:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com,
        arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, sreekumar.c@samsung.com
References: <1342188465-20239-1-git-send-email-vinholikatti@gmail.com> <201207131545.28877.arnd@arndb.de> <1342447217.3176.22.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1342447217.3176.22.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207161622.24063.arnd@arndb.de>
X-Provags-ID: V02:K0:sh0s6J+ZfktiCW/G/pPo7d3KutBwbTQgL1An55lfgH7
 KrdQ2fiMihIcCMqFUfflRX6dIpqezauv5qbARn5Xr2IeG87KKK
 R8X48WLBAZlB4+0DUpPuxL/q7Sprcx3G5SnN640sVQt4IrrFMB
 EOwdPEPjMiKrfviEEroAmHFGpduWsKD0sTT/URzAoBmdJXnNOs
 d7uTaMuWLiMt/AFqNOuTX22vncJtj24zhW3iLz7xSvRwjXpJPH
 xhKrxkGVEyRifwFJBZRZnJc15E04GmmUbc7JYPADMDCUuvdEiu
 RMyCZWqduA6aaGgwxfUkjaOZaIIZ5j8Axvq9ecRnLiTVKz/0OY
 GwvpyaMUr+7UFC+C5L7E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2012, James Bottomley wrote:
> On Fri, 2012-07-13 at 15:45 +0000, Arnd Bergmann wrote:
> > On Friday 13 July 2012, Vinayak Holikatti wrote:
> > > This patch set adds following features
> > >  - Seprates PCI specific code from ufshcd.c to make it as core
> > >  - Adds PCI glue driver ufshcd-pci.c
> > >  - Adds Platform glue driver ufshcd-pltfrm.c
> > >  - Update correct transfer size in Command UPIU
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> I need a maintainer ack for this to go upstream.
> 
> Also, looking at this, I think this patch series isn't bisectable:
> Patch 1 removes PCI support and patch 2 adds it back in a different
> form.  However, any PCI based UFS system would stop working if the
> bisect landed at patch 1.  I think you can fix this just by combining
> patches 1 and 2.

I suggested to split the patch in two in a private review that we
did on the linaro mailing list. I gave my Ack because the split
was done, but I failed to notice that it was done differently
from what I suggested in 

On Monday 02 July 2012, Arnd Bergmann wrote:
> I would recommend that you split this patch into two separate
> changesets, where you do all the changes to existing code in the
> first patch, and only move but don't change code in the second one
> that creates the new file.

I agree that breaking bisectibility by ripping out the PCI code
first is not good. The version 2 is not actually easier to review
at all than the first version, it just splits the changes by
file, which is pointless.

	Arnd

