Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1LDP7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 10:59:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51199 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232Ab1LDP7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 10:59:13 -0500
Date: Sun, 4 Dec 2011 15:59:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v8
Message-ID: <20111204155912.GB16287@opensource.wolfsonmicro.com>
References: <1321607994.10344.20.camel@dhruva> <20111124120541.GG8470@opensource.wolfsonmicro.com> <C3AE124F08223B42BC95AEB82F0F6CED1F9CFD03@KCHJEXMB01.kpit.com> <20111202140304.GT8245@opensource.wolfsonmicro.com> <C3AE124F08223B42BC95AEB82F0F6CED1F9CFD44@KCHJEXMB01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1F9CFD44@KCHJEXMB01.kpit.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 11:50:02AM +0000, Ashish Jangam wrote:

You should fix your mailer to word wrap at less than 80 columns, I've
reflowed your text for legibility.

> > > regmap-irq has a opaque struct regmap_irq_chip_data which has a member
> > > irq_base and this is required for non-primary irqs registration
> > > and also the clean-up function regmap_del_irq_chip() requires it.
> > > So as of now I will keep the current irq implementation as it is.

> > I'm not sure how this is relevant to my above comment?  The struct is of
> > course opaque since it is only used by the implementation.

> No issues on that but it has got irq_base as its member which gets
> initialize in the function regmap_add_irq_chip() and since this member
> value is not available to the user how can the mfd dependent modules
> like touch, battery etc can register for interrupt because during irq
> registration we add irq_base to the irq nmber for e.g. irq_base +
> battery_irq  

There's several straightforward solutions to that - for example, we can
add an accessor to retrieve the information, we can use resources to
pass the interrupt ranges to the MFD children or we can have the core
remember the interrupt base it's passing on to the children.

Whichever one we choose we can certainly solve the problem without
replicating the entire interrupt controller implementation.
