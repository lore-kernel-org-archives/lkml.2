Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab2INHSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:18:09 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:50473 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756254Ab2INHSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:18:06 -0400
Message-ID: <5052DA55.5080102@ti.com>
Date: Fri, 14 Sep 2012 10:18:45 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>, Ricardo Neri <ricardo.neri@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dan Williams <djbw@fb.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [alsa-devel] [PATCH v2 03/15] dmaengine: Add no_wakeup parameter
 to dmaengine_prep_dma_cyclic()
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com> <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com> <5051FB4D.3000009@metafoo.de> <1347593217.1943.26.camel@vkoul-udesk3>
In-Reply-To: <1347593217.1943.26.camel@vkoul-udesk3>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 06:26 AM, Vinod Koul wrote:
> On Thu, 2012-09-13 at 17:27 +0200, Lars-Peter Clausen wrote:
>> Hi,
>>
>> Hm... Do you think it would work as well if we implement this by
>> setting the
>> callback for the descriptor to NULL? If the callback is NULL there is
>> nothing to at the end of a transfer/period and the dma engine driver
>> may
>> choose to disable interrupts. This would also benefit non cyclic
>> transfers
>> where the callback is NULL and we do not need add the new parameter to
>> dmaengine_prep_dma_cyclic.
> That will work too.... BUT the idea of no_wake mode in ALSA is that we
> should not have any interrupts, so anything which is going to cause
> interrupts to AP in undesired. The interrupts still happen and it just
> that dmaengine driver is not notifying client.

Yes, this is correct. We could go and hack around later if the callback is not
present and modify the irq requests for the platform but it is really not
elegant way of dealing with the issue IMHO.


-- 
Péter
