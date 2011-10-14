Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1JNLYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:24:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54693 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1JNLYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:24:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAHj3AV=vRazPzpTFFYfRKXEeWSRqFLDYSq=XyYk597870oPA=w@mail.gmail.com>
References: <CAHj3AV=Sht2D6XREsmNrk=5Cmt0RxtKAHXzk=NWp26=o=bZjPA@mail.gmail.com>
 <1318535362-3964-1-git-send-email-mark.einon@gmail.com> <CAHj3AV=vRazPzpTFFYfRKXEeWSRqFLDYSq=XyYk597870oPA=w@mail.gmail.com>
From: Mark Einon <mark.einon@gmail.com>
Date: Fri, 14 Oct 2011 12:24:18 +0100
Message-ID: <CANK3SE1bvOwSgO2M6d==9aC9wDpAeemyam-67tLMeGHE1LjCmA@mail.gmail.com>
Subject: Re: [PATCH] staging: et131x: Match dma_alloc_ calls with dma_free_ calls
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2011 08:49, Denis Kirjanov <kirjanov@gmail.com> wrote:
> Well, I suggest to update the whole driver in one shot rather then
> updating it partially.
>

I did look at the pci_map_* calls, and noted that they are just
wrappers for the dma_map_* equivalents, so left them.

I've since dug around a bit more on the mailing lists and found that
there is a movement towards using the dma_ versions, so I've added
converting the rest of the functions to use the dma api to my todo
list.

Thanks for the heads up.

Regards,

Mark

> On Thu, Oct 13, 2011 at 11:49 PM, Mark Einon <mark.einon@gmail.com> wrote:
>> Previous update was to replace pci_alloc with dma_alloc calls. I missed
>> replacing the corresponding pci_free_ calls with the dma versions. Now
>> done. Thanks to Denis Kirjanov <kirjanov@gmail.com> for pointing this
>> out.
>>
>> Signed-off-by: Mark Einon <mark.einon@gmail.com>
>> ---
>>  drivers/staging/et131x/et131x.c |   16 ++++++++--------
>>  1 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
>> index 06ba4a9..28d54b3 100644
>> --- a/drivers/staging/et131x/et131x.c
>> +++ b/drivers/staging/et131x/et131x.c
>> @@ -2238,7 +2238,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
>>                                    (rx_ring->fbr[0]->buffsize * FBR_CHUNKS) +
>>                                    fbr1_align - 1;
>>
>> -                               pci_free_consistent(adapter->pdev,
>> +                               dma_free_coherent(&adapter->pdev->dev,
>>                                        bufsize,
>>                                        rx_ring->fbr[0]->mem_virtaddrs[index],
>>                                        rx_ring->fbr[0]->mem_physaddrs[index]);
>> @@ -2254,7 +2254,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
>>                bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries)
>>                                                            + 0xfff;
>>
>> -               pci_free_consistent(adapter->pdev, bufsize,
>> +               dma_free_coherent(&adapter->pdev->dev, bufsize,
>>                                    rx_ring->fbr[0]->ring_virtaddr,
>>                                    rx_ring->fbr[0]->ring_physaddr);
>>
>> @@ -2272,7 +2272,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
>>                                    (rx_ring->fbr[1]->buffsize *
>>                                     (FBR_CHUNKS + 1)) - 1;
>>
>> -                               pci_free_consistent(adapter->pdev,
>> +                               dma_free_coherent(&adapter->pdev->dev,
>>                                        bufsize,
>>                                        rx_ring->fbr[1]->mem_virtaddrs[index],
>>                                        rx_ring->fbr[1]->mem_physaddrs[index]);
>> @@ -2288,7 +2288,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
>>                bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries)
>>                                                            + 0xfff;
>>
>> -               pci_free_consistent(adapter->pdev,
>> +               dma_free_coherent(&adapter->pdev->dev,
>>                                    bufsize,
>>                                    rx_ring->fbr[1]->ring_virtaddr,
>>                                    rx_ring->fbr[1]->ring_physaddr);
>> @@ -2303,7 +2303,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
>>                    sizeof(struct pkt_stat_desc) *
>>                    adapter->rx_ring.psr_num_entries;
>>
>> -               pci_free_consistent(adapter->pdev, pktstat_ringsize,
>> +               dma_free_coherent(&adapter->pdev->dev, pktstat_ringsize,
>>                                    rx_ring->ps_ring_virtaddr,
>>                                    rx_ring->ps_ring_physaddr);
>>
>> @@ -2312,7 +2312,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
>>
>>        /* Free area of memory for the writeback of status information */
>>        if (rx_ring->rx_status_block) {
>> -               pci_free_consistent(adapter->pdev,
>> +               dma_free_coherent(&adapter->pdev->dev,
>>                        sizeof(struct rx_status_block),
>>                        rx_ring->rx_status_block, rx_ring->rx_status_bus);
>>                rx_ring->rx_status_block = NULL;
>> @@ -3038,7 +3038,7 @@ void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
>>                /* Free memory relating to Tx rings here */
>>                desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX)
>>                                                                + 4096 - 1;
>> -               pci_free_consistent(adapter->pdev,
>> +               dma_free_coherent(&adapter->pdev->dev,
>>                                    desc_size,
>>                                    adapter->tx_ring.tx_desc_ring,
>>                                    adapter->tx_ring.tx_desc_ring_pa);
>> @@ -3047,7 +3047,7 @@ void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
>>
>>        /* Free memory for the Tx status block */
>>        if (adapter->tx_ring.tx_status) {
>> -               pci_free_consistent(adapter->pdev,
>> +               dma_free_coherent(&adapter->pdev->dev,
>>                                    sizeof(u32),
>>                                    adapter->tx_ring.tx_status,
>>                                    adapter->tx_ring.tx_status_pa);
>> --
>> 1.7.6.4
>>
>>
>
>
>
> --
> Regards,
> Denis
>
