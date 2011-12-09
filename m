Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1LITZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:25:07 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:22186 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1LITZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:25:05 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EE2608B.4000103@freescale.com>
Date: Fri, 9 Dec 2011 13:24:59 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: <shuo.liu@freescale.com>
CC: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>,
        <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>
Subject: Re: [PATCH 2/2 v4] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1323423775-26951-1-git-send-email-shuo.liu@freescale.com> <1323423775-26951-2-git-send-email-shuo.liu@freescale.com>
In-Reply-To: <1323423775-26951-2-git-send-email-shuo.liu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 03:42 AM, shuo.liu@freescale.com wrote:
> From: Liu Shuo <shuo.liu@freescale.com>
> 
> Freescale FCM controller has a 2K size limitation of buffer RAM. In order
> to support the Nand flash chip whose page size is larger than 2K bytes,
> we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
> them to a large buffer.
> 
> Signed-off-by: Liu Shuo <shuo.liu@freescale.com>
> Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> v4 : allocate (8+1)k buffer for large page chip.
> 
>  drivers/mtd/nand/fsl_elbc_nand.c |  246 ++++++++++++++++++++++++++++++++++----
>  1 files changed, 221 insertions(+), 25 deletions(-)

Again, I think we need to sort out the bad block migration first -- at
least how we're going to mark the chip as having been migrated, so the
driver can check for it.

-Scott

