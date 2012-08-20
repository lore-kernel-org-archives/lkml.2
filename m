Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab2HTPKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:10:01 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58923 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab2HTPJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:09:57 -0400
MIME-Version: 1.0
In-Reply-To: <50324835.6030806@gmail.com>
References: <1345462769-17386-1-git-send-email-aletes.xgr@gmail.com>
	<50324835.6030806@gmail.com>
Date: Mon, 20 Aug 2012 17:09:57 +0200
Message-ID: <CACRpkdbJkL9bD-hG29LmB1mPAUpg5kwdQEfkMKNV4vRM9Sq87g@mail.gmail.com>
Subject: Re: [PATCH RESEND v4] spi/pl022: add devicetree support
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Roland Stigge <stigge@antcom.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        "Mark Brown (broonie@opensource.wolfsonmicro.com)" 
	<broonie@opensource.wolfsonmicro.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, sachin.verma@st.co
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 4:22 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 08/20/2012 06:39 AM, Alexandre Pereira da Silva wrote:

>> +- pl022,hierarchy : master or slave interface
>
> Is attaching a master and using the pl022 as a slave really a supported
> use case?

No not currently. People doing this crazy stuff need to have
the kernel with the hard real-time patches and lightening response
first. But it's in the platform data because it's a feature supported by
the hardware.

> The DT spi bindings are really designed for a master node with
> N slave nodes. So there is more general question of how to describe a
> spi controller as a slave. It's not really one I care to answer as the
> Linux spi framework isn't designed to act as a slave.

Currently the code should hardwire this to master and not define
a binding for it I think.

>> +- pl022,slave-tx-disable : disconnect tx line in slave mode

Applies also to this, then.

>> +- pl022,com-mode : polling, interrupt or dma
>> +- pl022,rx-level-trig : Rx FIFO watermark level
>> +- pl022,tx-level-trig : Tx FIFO watermark level
>> +- pl022,ctrl-len : Microwire interface: Control length
>> +- pl022,wait-state : Microwire interface: Wait state
>> +- pl022,duplex : Microwire interface: Full/Half duplex
>
> Most of these properties aren't used anywhere in the kernel other than
> u300 and I'm not sure what to purpose of dummy_chip_info is.

It is used for loopback-testing of the PL022. They're probably
not necessary there either.

> Perhaps
> Linus has some input? I think either they can be decided by the spi
> controller (com-mode, fifo watermark) or should be standard properties
> (microwire settings). I would argue they should be removed if the spi
> framework doesn't have support in a standard way.

Uncertain about this, others would need to comment.
At some point there has been a chip needing these to be set
to some magic values.

Yours,
Linus Walleij
