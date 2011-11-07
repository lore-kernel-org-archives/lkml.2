Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab1KGSVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:21:44 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:37170 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755817Ab1KGSVn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:21:43 -0500
MIME-Version: 1.0
In-Reply-To: <87obwr1n9i.fsf@ti.com>
References: <1320185752-568-1-git-send-email-omar.ramirez@ti.com>
	<1320185752-568-5-git-send-email-omar.ramirez@ti.com>
	<87obwr1n9i.fsf@ti.com>
Date: Mon, 7 Nov 2011 12:21:41 -0600
Message-ID: <CAB-zwWhkdv430aD8Osgi7Kyi6ScvhkwZ7BSW1cs3Nyzxc10VYg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] OMAP3/4: iommu: adapt to runtime pm
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        lo <linux-omap@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lm <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 4, 2011 at 6:27 PM, Kevin Hilman <khilman@ti.com> wrote:
>> @@ -821,9 +820,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
>>       if (!obj->refcount)
>>               return IRQ_NONE;
>>
>> -     clk_enable(obj->clk);
>>       errs = iommu_report_fault(obj, &da);
>> -     clk_disable(obj->clk);
>>       if (errs == 0)
>>               return IRQ_HANDLED;
>
> I'm not terribly familiar with this IOMMU code, but this one looks
> suspiciou because you're removing the clock calls but not replacing them
> with runtime PM get/put calls.
>
> I just want to make sure that's intentional.  If so, you might want to
> add a comment about that to the changelog.

Yes it is intentional, reason is that in order to get an interrupt,
the device should be powered on in advance, right now it is working
because the modules share a common clock so the users of the
omap-iommu indirectly give power to it. However I made another change
to do pm_runtime_get/put on attach/detach so it doesn't rely on others
to keep the clocks on.

I'll add the comment.

Thanks,

Omar
