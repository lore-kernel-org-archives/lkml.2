Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab2KPJ5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:57:44 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:48222 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2KPJ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:57:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 1/3] gpio / ACPI: add ACPI support
Date: Fri, 16 Nov 2012 11:02:05 +0100
Message-ID: <2746620.3kEZE8KPDY@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121116081246.GP17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <20121116080549.GO17774@intel.com> <20121116081246.GP17774@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 16, 2012 10:12:46 AM Mika Westerberg wrote:
> On Fri, Nov 16, 2012 at 10:05:49AM +0200, Mika Westerberg wrote:
> > 
> > One more thing, sometimes we want to assign the handle like in the case of
> > SPI controller driver we set the master->dev.acpi_handle. In that case we
> > can't use DEVICE_ACPI_HANDLE() as is. Should we just do something like:
> > 
> > 	master->dev.acpi_handle = pdev->dev.acpi_handle;
> > 
> > or should we introduce some new macro that supports this?
> 
> Or we could just drop the cast from the macro and use the same.
> 
> 	#define DEVICE_ACPI_HANDLE(dev)	((dev)->acpi_handle)

Well, I'm not sure.  Perhaps it's better to add a new macro, like
ACPI_HANDLE(dev), defined as above and use it going forward (we can then
phase out the old one gradually).

However, let's leave the patches in this series as they are for now, we can
add that macro in a separate patch later.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
