Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab2DULTD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:19:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2DULSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:18:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Date: Sat, 21 Apr 2012 11:09:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng <aisheng.dong@freescale.com>,
        Huang Shijie <b32955@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de> <20120420053014.GK22219@S2101-09.ap.freescale.net> <20120420211108.GC12691@pengutronix.de>
In-Reply-To: <20120420211108.GC12691@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204211109.42732.arnd@arndb.de>
X-Provags-ID: V02:K0:uu0jWroixMsmmI5nTbjD23gy1sWmkmYLv0Y+ZB+nf26
 wOKUMV6q9dXLsq/ASXzqcYSB+15DGQL/SfLsMpPXUOAmqztCQf
 hw8PSF1gjxlbjgX9JUoOLeao/LqHDgi+2koMoBR/hTcX9MDOKx
 c8bY7zLMueSIVobJXOHbNrst2zh7FPVP5hwvsRDaDLgvg+G3LR
 9mgDBg7+b3xdW4/YIxzXUIzKOKA2L56HLLLzviEUTHKNu85N1f
 IGmJ8ifKkqeJtyJ7Pw3MtTvrQ/2HeJDbQR3azJlCDkXjXKXRGv
 QMty3lMk33NkBSFnCeseXQvAJ69Ac2CIEEIZpmuDs1gaRRXYIS
 yJjM8+zC2CXv36+4q6bI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2012, Wolfram Sang wrote:
> On Fri, Apr 20, 2012 at 01:30:17PM +0800, Shawn Guo wrote:
> > On Wed, Apr 18, 2012 at 11:20:19AM +0200, Wolfram Sang wrote:
> > > > If not, i guess include/linux/fsl which already exists may be the
> > > > right place.
> > > 
> > > Which is a bad choice in my book. linux/dma would have been the proper
> > > thing for mxs-dma.h, I'd think.
> > > 
> > If it already exists, it will be the proper place.  We do not want to
> > be too invasive to create folders in include/linux for every subsystem
> > for only the need of fsl drivers.
> 
> I think linux/dma would have made sense:
> 
> $:~/Kernel/linux/include/linux$ ll *dma*
> -rw-r--r-- 1 ninja ninja  1809 Apr 15 23:32 dma-attrs.h
> ...
> -rw-r--r-- 1 ninja ninja  2631 Apr 15 23:32 sh_dma.h
> -rw-r--r-- 1 ninja ninja   123 Mar 30 22:12 sirfsoc_dma.h
> -rw-r--r-- 1 ninja ninja  1784 Aug 20  2011 timb_dma.h

+1

> > On the other hand, I have seen a clear need for include/linux/fsl.
> > The following files are all good candidates to be moved there.
> > 
> >   include/linux/fsl_devices.h
> 
> I stumbled over this file some time ago. It is an arbitrary collection of stuff
> which should better be seperate. See 'fsl_spi_platform_data'? That should be
> cpm_spi_platform_data. It doesn't even fit to MPC5200 (which SPI driver
> unnecessarily includes this file), let alone i.MX, so calling it 'fsl' doesn't
> make sense at all. I fear similar confusion with a fsl-directory.

Agreed. I would much prefer to avoid any such vendor specific silos for where to
dump random code. A file for a company that makes both powerpc and arm SoCs
that have a few components in common but also share other components with other
SoCs of the respective architectures does not seem very useful to me.

> >   include/linux/fsl-diu-fb.h
> 
> Sadly, another bad choice. It should have gone to include/video like all other
> fb-drivers.
> 
> >   include/linux/fsl_hypervisor.h
> 
> And that could simply stay in include/linux then, like kvm does.

Well, we could also have a linux/virt/ directory. Unfortunately in both these
cases we have no choice any more because they contain ioctl data structures
that are exported to user space, so we cannot move these files without
breaking user space programs and we don't do that.

	Arnd

