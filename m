Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1K1Vlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:41:37 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:21628
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648Ab1K1Vlf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:41:35 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371Kc89bh1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4ED3FFFC.50807@freescale.com>
Date: Mon, 28 Nov 2011 15:41:16 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: LiuShuo <b35362@freescale.com>
CC: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>,
        <linux-mtd@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, Liu Shuo <Shuo.Liu@freescale.com>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>
Subject: Re: [PATCH v3 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1321349355-1639-1-git-send-email-b35362@freescale.com> <1321349355-1639-2-git-send-email-b35362@freescale.com> <1321349355-1639-3-git-send-email-b35362@freescale.com> <4ECC368C.3010801@freescale.com> <4ECCE393.2030600@freescale.com>
In-Reply-To: <4ECCE393.2030600@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 06:14 AM, LiuShuo wrote:
> 于 2011年11月23日 07:55, Scott Wood 写道:
>> On 11/15/2011 03:29 AM, b35362@freescale.com wrote:
>>> From: Liu Shuo<b35362@freescale.com>
>>>
>>> -        if (elbc_fcm_ctrl->oob || elbc_fcm_ctrl->column != 0 ||
>>> +        if (elbc_fcm_ctrl->column>= mtd->writesize) {
>>> +            /* write oob */
>>> +            if (priv->page_size>  1) {
>>> +                /* when pagesize of chip is greater than 2048,
>>> +                 * we have to write full page to write spare
>>> +                 * region, so we fill '0xff' to main region
>>> +                 * and some bytes of spare region which we
>>> +                 * don't want to rewrite.
>>> +                 * (write '1' won't change the original value)
>>> +                 */
>>> +                memset(elbc_fcm_ctrl->buffer, 0xff,
>>> +                        elbc_fcm_ctrl->column);
>> I don't like relying on this -- can we use RNDIN instead to do a
>> discontiguous write?
>>
> I have no better way to implement it now.
> Some chips have 'NOP' limitation, so I don't use the FIR_OP_UA to do a
> oob write.

I don't think each RNDIN counts separately against NOP (someone correct
me if I'm wrong).  You're writing discontiguous regions of the page in
one operation.

-Scott

