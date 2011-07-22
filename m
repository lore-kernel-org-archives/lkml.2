Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1GVWcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:32:54 -0400
Received: from mga12.intel.com ([143.182.124.36]:24745 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999Ab1GVWcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:32:53 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jul 2011 18:32:53 EDT
MIME-Version: 1.0
In-Reply-To: <CAJe_Zhc4uJB8N9i2w38zzP3+XxcYF2v-zwsrhERWSi-yObV-6A@mail.gmail.com>
References: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
	<1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
	<CACRpkdbWHmob3EWJc6u5=yh=rNwVSR5hu9-Xud5kvQNU9-POtA@mail.gmail.com>
	<CAJe_Zhc4uJB8N9i2w38zzP3+XxcYF2v-zwsrhERWSi-yObV-6A@mail.gmail.com>
Date: Fri, 22 Jul 2011 15:23:21 -0700
Message-ID: <CABE8wwt7dkwgeahYBSUufOvJmVNfYyTss6U5qBgjJk9RVLBkYg@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 10:43 AM, Jaswinder Singh
<jaswinder.singh@linaro.org> wrote:
> On 22 July 2011 20:57, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Thu, Jul 21, 2011 at 6:01 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>>
>>> A DMAC driver might put chan_id to better use by directly
>>> mapping system-wide channel numbers on them (and not DMAC
>>> relative index).
>>
>> Sorry, not following this, is the idea that instead of each DMAC
>> numbering its own channels [0...N] you want to establish a global
>> channel index number [0..N] that is unique across all DMACs
>> in the system, even if you have several of them?
>>
> Something like that.
> Some DMACs 'think' they set the chan_id but it is immidiately overwritten
> by dma_async_device_register()
>
> So it's not clear whose job is to set it. Apparently the core is just
> "doing it for the DMAC driver".
>
> First of all, we need to see if we really want the dmaengine.c to
> set it's value?
> I think not, because there is no way for a DMAC driver to assign
> actually usable channel numbers to chan_id -- there might be 'holes'
> in the channel sequence of a DMAC. For ex, some channels of a DMAC
> don't reach any peripheral in a particular SoC.
> So the 'contiguous' sysfs entries 'dma%dchan%d' only depict
> mock numbering, which I am not sure is any useful.
>
> Also, it should be possible to map channel suitability (job of filter function)
> onto unique channel ID in a platform.
> So client drivers could simply do
>
> bool filter_fn(struct dma_chan *chan, void *ch)
> {
>       return chan->chan_id == ch;
> }
>
> And this, imho, should be what we should strive for if we are to have
> common clients over different DMACs.

The chan_id really is just a presentation detail to sysfs.  Just like
scsi host numbers they simply identify that they are distinct but the
number has no significant meaning inside the kernel to the driver
stack.

Unless you guaranteed that every id is globally unique I don't see how
they are generically usable by common clients?
