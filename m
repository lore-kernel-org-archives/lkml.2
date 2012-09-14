Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab2ININL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:13:11 -0400
Received: from smtp-out-028.synserver.de ([212.40.185.28]:1059 "EHLO
	smtp-out-028.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab2INIMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:12:53 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 19496
Message-ID: <5052E72A.8040207@metafoo.de>
Date: Fri, 14 Sep 2012 10:13:30 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH v2 03/15] dmaengine: Add no_wakeup parameter to dmaengine_prep_dma_cyclic()
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>  <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com>  <5051FB4D.3000009@metafoo.de> <1347593217.1943.26.camel@vkoul-udesk3>
In-Reply-To: <1347593217.1943.26.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 05:26 AM, Vinod Koul wrote:
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

Well, the idea was that the driver would disable interrupts if there is no
callback to call, since there would be nothing to do in the interrupt
handler anyway. But I guess the flags approach should work fine as well.
