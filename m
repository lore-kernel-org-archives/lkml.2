Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1JQOKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:10:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53551 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1JQOKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:10:23 -0400
MIME-Version: 1.0
In-Reply-To: <1318859861.23438.137.camel@vkoul-udesk3>
References: <1318844199-19303-1-git-send-email-Barry.Song@csr.com>
	<1318859861.23438.137.camel@vkoul-udesk3>
Date: Mon, 17 Oct 2011 16:10:22 +0200
Message-ID: <CACRpkdadRanBUNQZQMEX6En8A-=spqJUojOOrGAmTCJzMfvo7g@mail.gmail.com>
Subject: Re: [PATCH v3] dmaengine: add CSR SiRFprimaII DMAC driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Barry Song <Barry.Song@csr.com>, Arnd Bergmann <arnd@arndb.de>,
        Jassi Brar <jaswinder.singh@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 3:57 PM, Vinod Koul <vinod.koul@intel.com> wrote:

>> +     if (sdesc->cyclic) {
>> +             writel((1 << cid) | 1 << (cid + 16) |
>> +                     readl_relaxed(sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL),
>> +                     sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL);
>> +             schan->happened_cyclic = schan->completed_cyclic = 0;
>> +     }
>
> any reason why we have mixed use of writel_relaxes and writel?
> Shouldn't all the DMA register writes be done only using writel?

We has a lengthy discussion on the subject here:
http://marc.info/?l=linux-arm-kernel&m=130588591415130&w=2

Yours,
Linus Walleij
