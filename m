Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2ECN3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:29:01 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:53208 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270Ab2ECN3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:29:00 -0400
Message-ID: <4FA2881B.6010902@ti.com>
Date: Thu, 03 May 2012 16:28:59 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120503 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
References: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com> <1336049665-27777-3-git-send-email-peter.ujfalusi@ti.com> <20120503132004.GB14296@sirena.org.uk>
In-Reply-To: <20120503132004.GB14296@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 04:20 PM, Mark Brown wrote:
> On Thu, May 03, 2012 at 03:54:24PM +0300, Peter Ujfalusi wrote:
> 
>>  	/* In order to operate correctly we need valid interrupt config */
>> -	if (!client->irq || !pdata->irq_base) {
>> +	if (!client->irq) {
> 
> It looks like you're totally removing the use of irq_base which will
> break any boards that didn't convert to DT.  The usual idiom is to use
> irq_base as the base for the range of requested IRQs if it's supplied,
> otherwise set it to -1 to allow dynamic allocation.  This should keep
> existing users working without disruption.

In the current board files the pdata->irq_base set to some #defined
value (which is a comfortably big number).
With irq_alloc_descs(-1, 0, nr_irqs, 0); the range which can accommodate
the number of IRQs twl6040 will be provided so there is no need to me to
use the board specified irq_base.
The irq_base will be removed from the pdata structure, but that change
will go via linux-omap to avoid compile breakage.
This part is in preparation for DT, yes, but it is working without DT.
The twl6040 irq range is mapped to different numbers, that's all.

-- 
Péter
