Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1FIGzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:55:15 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:54541 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab1FIGzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:55:11 -0400
Message-ID: <4DF06E29.4010807@st.com>
Date: Thu, 9 Jun 2011 12:24:33 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <anemo@mba.ocn.ne.jp>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Why move all map_sg/unmap_sg for slave channel to its client?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I thought map_sg/unmap_sg for slave channels will be handled according
to the flags passed in prep_slave_sg(). But then i found following patch:

commit 657a77fa7284d8ae28dfa48f1dc5d919bf5b2843
Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date:   Tue Sep 8 17:53:05 2009 -0700

    dmaengine: Move all map_sg/unmap_sg for slave channel to its client
    
    Dan Williams wrote:
    ... DMA-slave clients request specific channels and know the hardware
    details at a low level, so it should not be too high an expectation to
    push dma mapping responsibility to the client.
    
    Also this patch includes DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE support for
    dw_dmac driver.
    
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/at_hdmac.c       |   43 +++++++++++++++++++++--------------------
 drivers/dma/dw_dmac.c        |   31 ++++++++++++++++++-----------
 drivers/mmc/host/atmel-mci.c |    9 +++++++-
 3 files changed, 49 insertions(+), 34 deletions(-)


I don't have much knowledge about that discussion, but i think this should be left
configurable. If the client wants to control map/unmap then it can simply pass
DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP in flags. I didn't wanted to
skip this in my driver and so i don't pass them.

Why to replicate similar code in client drivers if they need to unmap? What do you say?

-- 
viresh
