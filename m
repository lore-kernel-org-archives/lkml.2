Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1FGOCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:02:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44278 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1FGOC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:02:29 -0400
Date: Tue, 7 Jun 2011 16:02:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, anish <anish198519851985@gmail.com>,
        gregkh@suse.de, manuel.stahl@iis.fraunhofer.de,
        lucas.demarchi@profusion.mobi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] staging iio: Replace kmalloc with local variable
Message-ID: <20110607160206.6cb3168d@endymion.delvare>
In-Reply-To: <20110607134135.GD15795@trinity.fluff.org>
References: <1307450354.1516.23.camel@anish-desktop>
	<4DEE20E7.4020008@cam.ac.uk>
	<20110607134135.GD15795@trinity.fluff.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011 14:41:35 +0100, Ben Dooks wrote:
> On Tue, Jun 07, 2011 at 02:00:23PM +0100, Jonathan Cameron wrote:
> > On 06/07/11 13:39, anish wrote:
> > > From: anish kumar <anish198519851985@gmail.com>
> > > 
> > > replaced kmalloc with local variable as I2C(in this case) doesn't require
> > > kmalloc memory it can do with stack memory.
> > I've cc'd linux-i2c just to check I'm right about the whole i2c doesn't need
> > dma safe buffers bit...
> 
> No, it is down to the i2c driver, and from recollection dma from stack is
> not recommended, due to things like cache line alignment. Please do not
> do this.

To be clearer, it is down to the i2c BUS (adapter) driver, NOT the i2c
device driver. So the patch is correct.

Keep in mind that not all I2C/SMBus controllers care about DMA. In fact,
most don't (at least in the set I am maintaining - might be different
an embedded.) So calling kmalloc for every transfer in every I2C device
driver "just in case" is very much counterproductive.

And, if a controller does DMA and needs well-aligned, dynamically
allocated buffer, its driver would hopefully allocate the buffer ONCE
and keep it around, rather than reallocating it for every transfer.

-- 
Jean Delvare
