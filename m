Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1HBMCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 08:02:23 -0400
Received: from ist.d-labs.de ([213.239.218.44]:52709 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab1HBMCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 08:02:17 -0400
Date: Tue, 2 Aug 2011 14:02:15 +0200
From: Florian Mickler <florian@mickler.org>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tino Keitel <tino.keitel@tikei.de>,
        mchehab@infradead.org
Subject: Re: USB related "unable to handle kernel paging request" in
 3.0.0-rc7
Message-ID: <20110802140215.008ecfa6@schatten.dmk.lab>
In-Reply-To: <20110802113554.GC4516@shale.localdomain>
References: <20110722192722.GA9369@x61.home>
	<20110802085447.GA4522@shale.localdomain>
	<20110802115145.25b6a445@schatten.dmk.lab>
	<20110802124028.3b8dcd5a@schatten.dmk.lab>
	<20110802113554.GC4516@shale.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 14:35:54 +0300
Dan Carpenter <error27@gmail.com> wrote:

> On Tue, Aug 02, 2011 at 12:40:28PM +0200, Florian Mickler wrote:
> > This should fix it. 
> > 
> 
> That's not right.  You should just make .size_of_priv = 20 with a
> comment.

Right. Don't know why I didn't do so right from the start. The thing
is, the buffer has to be seperately allocated from the heap in order
for it to be used as a dma target. 
I probably overlooked that that is what actually happens in
dvb_usb_device_init. Or realized and changed everything accordingly but
forgot the .size_of_priv. ? 

Anyway, that is what you get if you can't actually test what you do. 
(Sorry Tino! The original patch submission had a big fat warning
that it was only compile tested, but that got lost somewhere along
the line...) 

> 
> regards,
> dan carpenter
> 

Thx,
Flo
