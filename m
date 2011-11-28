Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1K1Vti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:49:38 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:33250
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053Ab1K1Vtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:49:36 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4ED401ED.90703@freescale.com>
Date: Mon, 28 Nov 2011 15:49:33 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: LiuShuo <b35362@freescale.com>
CC: David Woodhouse <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322095306-13156-1-git-send-email-b35362@freescale.com> <1322095306-13156-3-git-send-email-b35362@freescale.com> <4ED401B3.1020001@freescale.com>
In-Reply-To: <4ED401B3.1020001@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 03:48 PM, Scott Wood wrote:
> On 11/23/2011 06:41 PM, b35362@freescale.com wrote:
>> From: Liu Shuo <b35362@freescale.com>
>>
>> Freescale FCM controller has a 2K size limitation of buffer RAM. In order
>> to support the Nand flash chip whose page size is larger than 2K bytes,
>> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
>> them to a large buffer.
>>
>> Signed-off-by: Liu Shuo <b35362@freescale.com>
>> Signed-off-by: Li Yang <leoli@freescale.com>
>> ---
>>  drivers/mtd/nand/fsl_elbc_nand.c |  211 +++++++++++++++++++++++++++++++++++---
>>  1 files changed, 194 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
>> index d634c5f..c96e714 100644
>> --- a/drivers/mtd/nand/fsl_elbc_nand.c
>> +++ b/drivers/mtd/nand/fsl_elbc_nand.c
>> @@ -55,7 +55,9 @@ struct fsl_elbc_mtd {
>>  	struct device *dev;
>>  	int bank;               /* Chip select bank number           */
>>  	u8 __iomem *vbase;      /* Chip select base virtual address  */
>> -	int page_size;          /* NAND page size (0=512, 1=2048)    */
>> +	int page_size;          /* NAND page size, the mutiple of 2048.
>> +				 * (0=512, 1=2048, 2=4096, 4=8192....)
>> +				 */
> 
> Again, please remove this.  It was sort-of reasonable when it was a
> boolean that selected between slightly different programming models.  It
> doesn't make sense as "mtd->writesize == 512 ? 0 : mtd->writesize / 512".

Sorry, I meant "mtd->writesize == 512 ? 0 : mtd->writesize / 2048".

-Scott

