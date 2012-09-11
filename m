Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2IKFnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:43:50 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:48951 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647Ab2IKFns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:43:48 -0400
MIME-Version: 1.0
In-Reply-To: <1346764109-21174-1-git-send-email-gururaja.hebbar@ti.com>
References: <1346764109-21174-1-git-send-email-gururaja.hebbar@ti.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Tue, 11 Sep 2012 11:13:26 +0530
Message-ID: <CANfBPZ93ONzeYj=kD_7pbq=VBQLd98YM9BE9S+sPb3rrrXNFzQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: omap_hsmmc: Pass on the suspend failure to the PM core
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, cjb@laptop.org, nsekhar@ti.com,
        sudhakar.raj@ti.com, Vaibhav Bedia <vaibhav.bedia@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 6:38 PM, Hebbar, Gururaja <gururaja.hebbar@ti.com> wrote:
> From: Vaibhav Bedia <vaibhav.bedia@ti.com>
>
> In some cases mmc_suspend_host() is not able to claim the
> host and proceed with the suspend process. The core returns
> -EBUSY to the host controller driver. Unfortunately, the
> host controller driver does not pass on this information
> to the PM core and hence the system suspend process continues.
>
> In these cases the MMC core gets to an unexpected state
> during resume and multiple issues related to MMC crop up.
> 1. Host controller driver starts accessing the device registers
> before the clocks are enabled which leads to a prefetch abort.
> 2. A file copy thread which was launched before suspend gets
> stuck due to the host not being reclaimed during resume.
>
> To avoid such problems pass on the -EBUSY status to the PM core
> from the host controller driver. With this change, MMC core
> suspend might still fail but it does not end up making the
> system unusable. Suspend gets aborted and the user can try
> suspending the system again.
>

The last time we discussed this, didn't we plan to fix this differently ?
Holding the return code of mmc_suspend_host in a separate variable and
passing it to the caller
of omap_hsmmc_suspend looks more sane to me.
