Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1GYSzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:55:50 -0400
Received: from mga12.intel.com ([143.182.124.36]:47005 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751382Ab1GYSzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:55:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
References: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
	<1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
	<CACRpkdbWHmob3EWJc6u5=yh=rNwVSR5hu9-Xud5kvQNU9-POtA@mail.gmail.com>
	<CAJe_Zhc4uJB8N9i2w38zzP3+XxcYF2v-zwsrhERWSi-yObV-6A@mail.gmail.com>
	<CABE8wwt7dkwgeahYBSUufOvJmVNfYyTss6U5qBgjJk9RVLBkYg@mail.gmail.com>
	<CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
Date: Mon, 25 Jul 2011 11:55:45 -0700
Message-ID: <CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        vinod.koul@intel.com, rmk+kernel@arm.linux.org.uk,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 8:56 PM, Jaswinder Singh
<jaswinder.singh@linaro.org> wrote:
> On 23 July 2011 03:53, Williams, Dan J <dan.j.williams@intel.com> wrote:
>
>>
>> Unless you guaranteed that every id is globally unique I don't see how
>> they are generically usable by common clients?
>>
> Yes. And the first step is to allow DMAC drivers to freely set chan_id value.
> Platform could pass the list and mapping of supported 'global channels'
> via platform_data(?) which the DMAC drivers could set in chan_id
> And I am not sure of defining a new variable for that, because chan_id
> is actually used only by some dmac drivers for internal purpose only -
> which they could do by private variables.

Yes, it does appear to have grown a lot of dubious usage in
drivers/dma/ for something that is described as just a "channel ID for
sysfs".  The intent was for drivers that need to maintain their own
hardware specific identification to define a local id scheme (like
iop-adma does in the iop3xx case).

I can sort of see why it is attractive for the goal of having clients
being able to talk to multiple DMACs since it is a field that all
channels already implement.  But, I don't think we should be mixing
sysfs presentation details with a capability that indicates a certain
compatibility level in a DMAC driver implementation.  If the goal is
to be able to use a single client with multiple drivers that, to me,
is asking for a new capability bit (dma_transaction_type) rather than
an id.  Do you have an example of the client and the DMACs that would
first take advantage of such a cross DMAC compatibility?

> Proposal to have global cross-platform enum of channel-IDs defined by
> client drivers, was to be my next patch.
> Though I think, this patch is valid in it's own light.

This is not the purpose of chan_id.

--
Dan
