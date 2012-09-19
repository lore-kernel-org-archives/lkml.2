Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2ISFqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:46:15 -0400
Received: from void.printf.net ([89.145.121.20]:38294 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab2ISFpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:45:49 -0400
From: Chris Ball <cjb@laptop.org>
To: "S\, Venkatraman" <svenkatr@ti.com>
Cc: "Hebbar\, Gururaja" <gururaja.hebbar@ti.com>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        nsekhar@ti.com, sudhakar.raj@ti.com,
        Vaibhav Bedia <vaibhav.bedia@ti.com>
Subject: Re: [PATCH V2] mmc: omap_hsmmc: Pass on the suspend failure to the PM core
References: <1347517863-30017-1-git-send-email-gururaja.hebbar@ti.com>
	<CANfBPZ9hrKZgAbyUWfT7cLyRVDEEAVC7x=eBwFqBn49m-rmqkw@mail.gmail.com>
Date: Wed, 19 Sep 2012 01:46:10 -0400
In-Reply-To: <CANfBPZ9hrKZgAbyUWfT7cLyRVDEEAVC7x=eBwFqBn49m-rmqkw@mail.gmail.com>
	(Venkatraman S.'s message of "Tue, 18 Sep 2012 00:21:02 +0530")
Message-ID: <m34nmuk1jx.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 17 2012, S, Venkatraman wrote:
> On Thu, Sep 13, 2012 at 12:01 PM, Hebbar, Gururaja
> <gururaja.hebbar@ti.com> wrote:
>> From: Vaibhav Bedia <vaibhav.bedia@ti.com>
>>
>> In some cases mmc_suspend_host() is not able to claim the
>> host and proceed with the suspend process. The core returns
>> -EBUSY to the host controller driver. Unfortunately, the
>> host controller driver does not pass on this information
>> to the PM core and hence the system suspend process continues.
>>
>>         ret = mmc_suspend_host(host->mmc);
>>         if (ret) {
>>                 host->suspended = 0;
>>                 if (host->pdata->resume) {
>>                         ret = host->pdata->resume(dev, host->slot_id);
>>
>> The return status from mmc_suspend_host() is overwritten by return
>> status from host->pdata->resume. So the original return status is lost.
>>
>> In these cases the MMC core gets to an unexpected state
>> during resume and multiple issues related to MMC crop up.
>> 1. Host controller driver starts accessing the device registers
>> before the clocks are enabled which leads to a prefetch abort.
>> 2. A file copy thread which was launched before suspend gets
>> stuck due to the host not being reclaimed during resume.
>>
>> To avoid such problems pass on the -EBUSY status to the PM core
>> from the host controller driver. With this change, MMC core
>> suspend might still fail but it does not end up making the
>> system unusable. Suspend gets aborted and the user can try
>> suspending the system again.
>>
>> Signed-off-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
>> Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
>
> This version is good.
>
> Acked-by: Venkatraman S <svenkatr@ti.com>

Thanks, pushed to mmc-next for 3.7, with a stable@ tag added (right?).

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
