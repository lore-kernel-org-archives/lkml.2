Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2JLGg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:36:59 -0400
Received: from [213.199.154.205] ([213.199.154.205]:20570 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab2JLGg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:36:57 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441hbe9i1155h)
Subject: Re: [Patch v3 7/7] Onkey: DA9055 Onkey driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-input@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20121011162852.GB15588@core.coreip.homeip.net>
References: <1349952316.9228.7.camel@dhruva>
	 <20121011162852.GB15588@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Oct 2012 12:16:44 +0530
Message-ID: <1350024404.11527.3.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 09:28 -0700, Dmitry Torokhov wrote:
> Hi Ashish,
> 
> On Thu, Oct 11, 2012 at 04:15:16PM +0530, Ashish Jangam wrote:
> > This is the ONKEY driver of the Dialog DA9055 PMIC and depends on the DA9055 MFD
> > core driver.
> > 
> > This patch is functionally tested on SMDK6410 board.
> > 
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> > changes since v3:
> > - used of module_platform_driver macro
> > - add regmap virtual irq function
> > changes since v2:
> > - add support for button release
> > - use of devm_request_threaded_irq API
> 
> This API does not make any sense for your driver as you are scheduling
> delayed work from the IRQ handler. In such cases you need _first_ free
> IRQ and _then_ cancel the work but with devm_* you do it in opposite
> order.
I miss on this, will correct it.
> 
> Also, I think I mentioned this before - this driver looks like twin
> brother for da9055_onkey.c. How many of such parts do you have (or will
> you have)? Is there way to unify them?
Well, DA9052 and DA9055 register sets are entirely different even there
bit position are different and also few of its components have slight
different behaviour.  Device components functional difference can be
managed programmatic but, to unify these two different sets of register
will be impractical. In case of DA9052 I managed to club the DA9053
functionality within it but it was not possible for DA9055.
> 
> Thanks.
> 


