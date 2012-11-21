Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2KUIeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:34:00 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:50052 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359Ab2KUId7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:33:59 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zz1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631hbe9i1155h)
Subject: Re: [PATCH RFT] regulator: da9055: Properly handle voltage range
 that doesn't start with 0 offset
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: AxelLin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <dchen@diasemi.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED38A89780@KCHJEXMB03.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED38A89780@KCHJEXMB03.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Nov 2012 14:03:02 +0530
Message-ID: <1353486782.1760.20.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch implements map_voltage and list_voltage callbacks to properly handle
> the case voltage range that doesn't start with 0 offset.
> 
> Now we adjust the selector in map_voltage() before calling set_voltage_sel().
> And return 0 in list_voltage() for invalid selectors.
> 
> With above change, we can remove da9055_regulator_set_voltage_bits function.
> 
> One tricky part is that we need adding voffset to n_voltages.
> Although for the cases "selector < voffset" are invalid, we need add voffset to
> n_voltage so regulator_list_voltage() won't fail while checking the boundary for
> selector before calling list_voltage callback.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Ashish,
>   I don't have this hardware to test this patch.
>   Can you help to review and test this patch?
> Thank you,
> Axel
This patch looks good to me.
I have tested this patch on SMDK6410 using the DA9055 evaluation board.
Tested-by: Ashish Jangam <ashish.jangam@kpitcummins.com>


