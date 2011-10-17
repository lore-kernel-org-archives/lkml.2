Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1JQSR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:17:58 -0400
Received: from mxout1.idt.com ([157.165.5.25]:38596 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1JQSR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:17:57 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Date: Mon, 17 Oct 2011 11:16:14 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202321F81@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <CAJe_ZhdjMTsqSTDwV_zaAQKmCbjOtRVc951wxqKScaCR-DBG9Q@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Thread-Index: AcyM5Ora3Qx635onQ0Cb9ZJTYzKjSwAElyZA
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com><1317492077.1573.1839.camel@vkoul-udesk3><0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com><1317965252.1573.2238.camel@vkoul-udesk3><0CE8B6BE3C4AD74AB97D9D29BD24E552022D6C9A@CORPEXCH1.na.ads.idt.com><1318700142.23438.45.camel@vkoul-udesk3> <CAJe_ZhdjMTsqSTDwV_zaAQKmCbjOtRVc951wxqKScaCR-DBG9Q@mail.gmail.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Jassi Brar <jaswinder.singh@linaro.org>, Vinod Koul <vinod.koul@intel.com>
CC: Dan <dan.j.williams@intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 11:53 AM, Jassi Brar
<jaswinder.singh@linaro.org> wrote:
> 
> On 15 October 2011 23:05, Vinod Koul <vinod.koul@intel.com> wrote:
> 
> > Another alternate approach could be to add one more argument to
> > prep_slave_sg API which allows us to pass additional runtime
specific
> > parameters. This can be NULL and unused for existing drivers and
used
> in
> > RIO and any future subsystems which want to use dmaengine.
> > Thoughts...?
> >
> That doesn't sound much different than passing the data via
> dma_chan.private during prep_slave_sg. Only now we add to
> the number of arguments.
One dma_chan may be used by multiple drivers requesting data transfer.
In this case we will need a lock to keep dma_chan and its private
coupled together. 
If we consider this coupling as a valid way we may think about
adding a lock member into dma_chan structure. This will make locking
more effective for configurations with multiple DMA channels. 

> And then either this argument would be RapidIO specific (unfair
> to other users) or generic. In latter case what would it look like ?
It should not be RapidIO specific. Just transfer specific context that
will be interpreted by participants. Given that we have a channel
filtering mechanism there is a little chance of wrongful usage of
that parameter.

Alex.
