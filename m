Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2GPOAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:00:25 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36473 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab2GPOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:00:23 -0400
Message-ID: <1342447217.3176.22.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH V2 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com,
        arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, sreekumar.c@samsung.com
Date: Mon, 16 Jul 2012 15:00:17 +0100
In-Reply-To: <201207131545.28877.arnd@arndb.de>
References: <1342188465-20239-1-git-send-email-vinholikatti@gmail.com>
	 <201207131545.28877.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 15:45 +0000, Arnd Bergmann wrote:
> On Friday 13 July 2012, Vinayak Holikatti wrote:
> > This patch set adds following features
> >  - Seprates PCI specific code from ufshcd.c to make it as core
> >  - Adds PCI glue driver ufshcd-pci.c
> >  - Adds Platform glue driver ufshcd-pltfrm.c
> >  - Update correct transfer size in Command UPIU
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

I need a maintainer ack for this to go upstream.

Also, looking at this, I think this patch series isn't bisectable:
Patch 1 removes PCI support and patch 2 adds it back in a different
form.  However, any PCI based UFS system would stop working if the
bisect landed at patch 1.  I think you can fix this just by combining
patches 1 and 2.

James


