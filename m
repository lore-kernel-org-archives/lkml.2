Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab1JXMhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:37:23 -0400
Received: from mxout1.idt.com ([157.165.5.25]:52569 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab1JXMhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:37:21 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: RE: [PATCHv4] DMAEngine: Define interleaved transfer request api
Date: Mon, 24 Oct 2011 05:36:53 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520236801F@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1319428149.9355.60.camel@vkoul-udesk3>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv4] DMAEngine: Define interleaved transfer request api
Thread-Index: AcySATrl8xkKJ1SmQnWyojcuPjiInwAR29Iw
References: <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com> <CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com> <CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com> <20111018074211.GA13483@flint.arm.linux.org.uk> <CAJe_ZhdHcsBNT6iX7TJCqoGZMrPwE2BOt06e8M8PHzuDe3Z70w@mail.gmail.com> <20111018094944.GA30644@flint.arm.linux.org.uk> <CAJe_ZhcDJjP3t_XFG04or4WzwzPHEcHo2ThstGCVFrYvYqTaiQ@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552023672A3@CORPEXCH1.na.ads.idt.com> <1319428149.9355.60.camel@vkoul-udesk3>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Barry Song <21cnbao@gmail.com>, <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9OCbTV4005946

On Sun, Oct 23, 2011 at 11:49 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> 
> On Tue, 2011-10-18 at 10:57 -0700, Bounine, Alexandre wrote:
> 
> > I would like to put a simple example of RIO based system that may
> help to
> > understand our DMA requirements.
> >
> > Consider a platform with one host CPU and several DSP cards connected
> > to it through a switched backplane (transparent for purpose of this
> example).
> >
> > The host CPU has one or more RIO-capable DMA channel and runs device
> > drivers for connected DSP cards. Each device driver is required to
> load
> > an individual program code into corresponding DSP(s). Directly
> addressed
> > writes have a lot of sense.
> >
> > After DSP code is loaded device drivers start DSP program and may
> > participate in data transfers between DSP cards and host CPU. Again
> > messaging type transfers may add unnecessary overhead here compared
> > to direct data reads/writes.
> >
> > Configuration of each DSP card may be different but from host's
> > POV is RIO spec compliant.
> 
> I think we all agree that this fits the dma_slave case :)
> 
> As for changing in dmaengine to u64, if we are thinking this as slave
> usage, then ideally we should not make assumption of the address type
> of
> peripheral so we should only move the dma_slave_config address fields
> to
> u64, if that helps in RIO case. Moving other usages would be insane.
> 
> At this point we have two proposals
> a) to make RIO exceptional case and add RIO specific stuff.
> b) make dmaengine transparent and add additional argument
> in .device_prep_slave_sg() callback which is subsystem dependent.
> Current dmacs and those who don't need it will ignore it.
> 
> ATM, I am leaning towards the latter, for the main reason to keep
> dmaengine away from subsystem details.
> 
Both proposals will work for RapidIO but second option looks more
universal and may be used by another subsystem in the future.
My vote goes to the option b).


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
