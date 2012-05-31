Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2EaJWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:22:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2EaJWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:22:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [RFC PATCH 0/5] omap: add ocp2scp as a misc driver
Date: Thu, 31 May 2012 09:22:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
References: <1338375394-16268-1-git-send-email-kishon@ti.com> <201205301843.51568.arnd@arndb.de> <CAAe_U6LFFstds=iQ7cy7gM9vWbfRgf5z0gaRp_-bu0Qjx6eA1Q@mail.gmail.com>
In-Reply-To: <CAAe_U6LFFstds=iQ7cy7gM9vWbfRgf5z0gaRp_-bu0Qjx6eA1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205310922.18550.arnd@arndb.de>
X-Provags-ID: V02:K0:siVXrMdLMG9lD4rXtFTEMRUcj2AAe+ZYs+P262gWvXJ
 3WDnZuvZBWr9R2HlHpcZFpuFMKweljyCsF1pFJLZSpfoeD1Bm4
 mtzH4+z0OJkSjKASkrt9Qqs2ZMVqc7JN3VFstcwngRkLrpoEUc
 wSrW+dg6g/S1TaxlcAZd1WmGGTrFAcBVGO65cCjPMzSdb+PO91
 GOFPbTaekuAxPbACeAZtqpIs73KPd7Lef4NqfEOTP1zuzqeo2y
 sRBwaRn8y0+h8R7N1WzRTx6SeJ30XstRY99zqxznURcpmrw3FK
 xkRZtIfehIupKx1B3F8NWHvnfnTOCSQnhWO8EJqsirWPTGijv7
 MwDC0DWNAxCN/v5IeXoE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 May 2012, ABRAHAM, KISHON VIJAY wrote:
> >
> > Just put the devices you actually want into the device tree instead and
> > have them automatically created.
> 
> But shouldn't device tree support and non-device tree support co-exist
> till the non-device tree is completely knocked out of the kernel? Even

Well, it's a new driver, so there is no regression in supporting it only
on DT-enabled boards. OMAP5 is DT-only anyway and OMAP4 only supports two
boards that should both be working with the generic DT code already.

> then shouldn't there be a separate driver to extract the child nodes
> of ocp2scp and create a device (using of_platform_populate)?
> As far as I've seen, the devices are automatically created (by virtue
> of of_platform_populate() in  mach-omap2/board-generic.c in omap case)
> only for the devices that is connected to the system bus. For other
> cases, the parent should be responsible for creating the child
> devices.

I would mark the multiplexed device compatible with "simple-bus", which
results in the child devices automatically getting added.

	Arnd
