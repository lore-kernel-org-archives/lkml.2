Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0EJITN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:19:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:55959 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0EJITK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:19:10 -0400
Message-ID: <4BE7C0FF.8070406@windriver.com>
Date: Mon, 10 May 2010 16:17:03 +0800
From: Bi Junxiao <junxiao.bi@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: davinci-linux-open-source@linux.davincidsp.com
CC: linux-kernel@vger.kernel.org
Subject: question about using DMA for davinci SPI controller
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 May 2010 08:19:08.0042 (UTC) FILETIME=[76244EA0:01CAF019]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to fix a bug about full duplex DMA transfer for SPI
controller hang on ti-omapl138 ref borad.
I read the DMA setting code of davinci SPI controller. It's in
drivers/spi/davinci_spi.c:davinci_spi_bufs_dma().
There is a code snippet which I don't understand. List below:

--------------------------------------------------------------------------------
if (t->tx_buf) {
t->tx_dma = dma_map_single(&spi->dev, (void *)t->tx_buf, count,
DMA_TO_DEVICE);
if (dma_mapping_error(&spi->dev, t->tx_dma)) {
dev_dbg(sdev, "Unable to DMA map a %d bytes"
" TX buffer\n", count);
return -ENOMEM;
}
temp_count = count;
} else {
/* We need TX clocking for RX transaction */
t->tx_dma = dma_map_single(&spi->dev,
(void *)davinci_spi->tmp_buf, count + 1,
DMA_TO_DEVICE);
if (dma_mapping_error(&spi->dev, t->tx_dma)) {
dev_dbg(sdev, "Unable to DMA map a %d bytes"
" TX tmp buffer\n", count);
return -ENOMEM;
}
temp_count = count + 1;
}
----------------------------------------------------------------------------------
My question is why the transfer count in else logic is count+1 but in if
logic it's only count?
When I changed it from count£«1 to count and use a test program to read
a spi flash, I found the DMA rx interrupt can not be triggered.
The test program hung for ever.

Would anybody have any idea about this?

Thanks.
