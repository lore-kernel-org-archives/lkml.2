Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1LLVQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:16:53 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:47246 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1LLVQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:16:48 -0500
X-SpamScore: -14
X-BigFish: VS-14(zzbb2dI9371I936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EE66EFE.1050608@freescale.com>
Date: Mon, 12 Dec 2011 15:15:42 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <shuo.liu@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>  <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>  <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala>
In-Reply-To: <1323724195.2297.11.camel@koala>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 03:09 PM, Artem Bityutskiy wrote:
> On Tue, 2011-12-06 at 18:09 -0600, Scott Wood wrote:
>> On 12/03/2011 10:31 PM, shuo.liu@freescale.com wrote:
>>> From: Liu Shuo <shuo.liu@freescale.com>
>>>
>>> Freescale FCM controller has a 2K size limitation of buffer RAM. In order
>>> to support the Nand flash chip whose page size is larger than 2K bytes,
>>> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
>>> them to a large buffer.
>>>
>>> Signed-off-by: Liu Shuo <shuo.liu@freescale.com>
>>> ---
>>> v3:
>>>     -remove page_size of struct fsl_elbc_mtd.
>>>     -do a oob write by NAND_CMD_RNDIN. 
>>>
>>>  drivers/mtd/nand/fsl_elbc_nand.c |  243 ++++++++++++++++++++++++++++++++++----
>>>  1 files changed, 218 insertions(+), 25 deletions(-)
>>
>> What is the plan for bad block marker migration?
> 
> Why it should be migrated? I thought that you support 2KiB pages, and
> this adds 4 and 8 KiB pages support, which you never supported before.
> What is the migration you guys are talking about?

NAND chips come from the factory with bad blocks marked at a certain
offset into each page.  This offset is normally in the OOB area, but
since we change the layout from "4k data, 128 byte oob" to "2k data, 64
byte oob, 2k data, 64 byte oob" the marker is no longer in the oob.  On
first use we need to migrate the markers so that they are still in the oob.

-Scott

