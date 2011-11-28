Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1K1RUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:20:39 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:14033
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab1K1RUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:20:38 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371K1432N98dKzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4ED3C2E2.9040601@freescale.com>
Date: Mon, 28 Nov 2011 11:20:34 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Li Yang-R58472 <r58472@freescale.com>
CC: Liu Shuo-B35362 <B35362@freescale.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322095306-13156-1-git-send-email-b35362@freescale.com> <1322095306-13156-3-git-send-email-b35362@freescale.com> <3F607A5180246847A760FD34122A1E052DC4CD@039-SN1MPN1-003.039d.mgd.msft.net>
In-Reply-To: <3F607A5180246847A760FD34122A1E052DC4CD@039-SN1MPN1-003.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 01:37 AM, Li Yang-R58472 wrote:
>> +static void io_to_buffer(struct mtd_info *mtd, int subpage, int oob)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct fsl_elbc_mtd *priv = chip->priv;
>> +	struct fsl_elbc_fcm_ctrl *elbc_fcm_ctrl = priv->ctrl->nand;
>> +	void *src, *dst;
>> +	int len = (oob ? 64 : 2048);
>> +
>> +	if (oob)
>> +		dst = elbc_fcm_ctrl->buffer + mtd->writesize + subpage * 64;
>> +	else
>> +		dst = elbc_fcm_ctrl->buffer + subpage * 2048;
>> +
>> +	src = elbc_fcm_ctrl->addr + (oob ? 2048 : 0);
>> +	memcpy_fromio(dst, src, len);
> 
> Might be safer to use _memcpy_fromio()

How so?

memcpy_fromio() is the public interface that will end up calling
_memcpy_fromio() on powerpc.

-Scott

