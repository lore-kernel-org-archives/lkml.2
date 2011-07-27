Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1G0QhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:37:01 -0400
Received: from mga12.intel.com ([143.182.124.36]:52776 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754796Ab1G0Qg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com>
References: <CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
	<CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com>
	<CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
	<CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
	<CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	<CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	<CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	<1311740499.1536.56.camel@vkoul-udesk3>
	<CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	<1311757347.1536.103.camel@vkoul-udesk3>
	<20110727095909.GB16623@intel.com>
	<CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com>
Date: Wed, 27 Jul 2011 09:36:54 -0700
Message-ID: <CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linus.walleij@stericsson.com,
        per.friden@stericsson.com, wei.zhang@freescale.com,
        ebony.zhu@freescale.com, iws@ovro.caltech.edu, s.hauer@pengutronix.de,
        maciej.sosnowski@intel.com, saeed@marvell.com, shawn.guo@freescale.com,
        yur@emcraft.com, agust@denx.de, iwamatsu.nobuhiro@renesas.com,
        per.forlin@stericsson.com, jonas.aberg@stericsson.com,
        anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 7:50 AM, Jaswinder Singh
<jaswinder.singh@linaro.org> wrote:
> On 27 July 2011 15:29, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
>
>> As the caps are not per channel, that is the only way I was able to make it
>> work.
> FWIW, my proposal(in other thread) tags capabilities to a channel.
>

Where is that other thread?

>> At least in ep93xx we have even channel numbers for TX and odd for RX (or
>> vice versa, can't rememeber). This is a hardware restriction. So the client
>> code then filters the channels based on that using ->chan_id.
> This should be a piece of cake to handle by my proposal.
>
> If interested please get involved in that thread and help check if it
> can make things better.

I think it is fine for chan_id to be disconnected from sysfs and given
to drivers as common field for some other purpose (not convinced that
1:N client-to-driver is a valid use for this single id, hence why I'd
like to see the full proposal).

But it definitely should not be a field that drivers control in
non-uniform ways and gets exposed to sysfs.  The chan_id for the class
device is just an opaque integer just like the host number for scsi
hba's.  If the user wants to know device specific details about that
channel that information can be retrieved by following the device
link.

For example:
# cat /sys/class/dma/dma0chan0/device/device
0x3c20

That is the actual hardware specific channel identification.  The
class device is not the hardware device, and having drivers set
chan_id to something hardware device specific conflates that fact.
Now, if you want a new/separate attribute of a class device that is
set in some uniform fashion that is a different discussion, but it's
not clear to me why sysfs would need to expose these details?

--
Dan
