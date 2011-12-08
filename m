Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1LHSn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:43:57 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:17557
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab1LHSn4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:43:56 -0500
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI9371Ic89bh98dKzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EE10568.9070002@freescale.com>
Date: Thu, 8 Dec 2011 12:43:52 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: LiuShuo <b35362@freescale.com>
CC: <shuo.liu@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com> <1322973098-2528-3-git-send-email-shuo.liu@freescale.com> <4EDEAEB9.6020703@freescale.com> <4EDEE3AC.7060000@freescale.com> <4EDFBA6D.9080500@freescale.com> <4EE09526.5040705@freescale.com>
In-Reply-To: <4EE09526.5040705@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 04:44 AM, LiuShuo wrote:
> 于 2011年12月08日 03:11, Scott Wood 写道:
>> And if we do want to make such assumptions, we could rip out all usage
>> of index/column here, and just handle "oob" and "full page" cases.
> The function nand_do_write_ops() in nandbase.c is a Nand internal
> interface.
> It always is called when application write to nand flash. (e.g. dd)
> In this function, partial page write is dealt with by filling '0xff' to
> buffer before data copy.
> (nand_do_write_oob() is similar)
> So I don't think we need to do it in our controller driver again, it
> should be a job of upper layer.

If this is to be considered part of the interface contract, then perhaps
do a WARN_ON() if we see an unexpected index/column?  And after that,
only consider full-page or full-oob possibilities.

-Scott

