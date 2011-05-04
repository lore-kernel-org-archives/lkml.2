Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1EDOnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:43:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49020 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1EDOnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:43:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110504143757.GB15967@pulham.picochip.com>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca> <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru> <20110503220408.GA6978@pulham.picochip.com>
 <20110503223415.GA14024@oksana.dev.rtsoft.ru> <20110504110939.GB13514@pulham.picochip.com>
 <20110504113131.GA639@oksana.dev.rtsoft.ru> <20110504143757.GB15967@pulham.picochip.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 4 May 2011 08:43:26 -0600
X-Google-Sender-Auth: tF2fz3AGY_vo-0Kw_nwKRuQNjGM
Message-ID: <BANLkTik8fOmeFCrKLnXsxQ9rAfjGedM9JQ@mail.gmail.com>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different controllers
To: Jamie Iles <jamie@jamieiles.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you repost as a proper series please?  Don't force me to muck
about with attachments.

g.

On Wed, May 4, 2011 at 8:37 AM, Jamie Iles <jamie@jamieiles.com> wrote:
> On Wed, May 04, 2011 at 03:31:31PM +0400, Anton Vorontsov wrote:
>> On Wed, May 04, 2011 at 12:09:39PM +0100, Jamie Iles wrote:
>> > On Wed, May 04, 2011 at 02:34:15AM +0400, Anton Vorontsov wrote:
>> > > On Tue, May 03, 2011 at 11:04:08PM +0100, Jamie Iles wrote:
>> > > [...]
>> > > > The advantage that Grant's proposal has though is that the user can
>> > > > override the gpio_chip callbacks.  When I tried porting over some
>> > > > existing ARM platforms, one of the blocking issues was that lots of
>> > > > platforms had some annoying small detail that was slightly different
>> > > > (such as doing muxing in the _get() callback or needing a to_irq
>> > > > callback).
>> > > >
>> > > > If we make bgpio_chip public and return that from bgpio_probe
>> > > > unregistered then the calling code can override some of the methods then
>> > > > register the gpio_chip.
>> > >
>> > > Oh, that makes sense, right.
>> >
>> > I've just given this a try and it largely works, but it's probably
>> > better if we allow bgpio_chip to be embedded in other structures.  For
>> > example, the langwell driver has a gpio_to_irq callback that we would
>> > need to get the IRQ base for the bank.  We could add a void *priv member
>> > to bgpio_chip but that doesn't feel quite right.
>> >
>> > So,
>> >     int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
>> >                    unsigned long sz, void __iomem *dat, ...)
>> >
>> > rather than a probe() that returns the bgpio_chip?
>>
>> Sounds good to me.
>
> OK, so here's what I've got so far (patches attached).  I've updated the
> basic_mmio_gpio library with your initial lkml patch and updated it to
> allow bgpio_chip to be embedded in another structure.  I've also
> attempted to convert over the bt8xx and langwell drivers but they're a
> little rough around the edges in places (and untested as I don't have
> the hardware).
>
> Jamie
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
