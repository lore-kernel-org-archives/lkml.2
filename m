Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1HBJvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:51:52 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41638 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1HBJvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:51:47 -0400
Date: Tue, 2 Aug 2011 11:51:45 +0200
From: Florian Mickler <florian@mickler.org>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tino Keitel <tino.keitel@tikei.de>,
        mchehab@infradead.org
Subject: Re: USB related "unable to handle kernel paging request" in
 3.0.0-rc7
Message-ID: <20110802115145.25b6a445@schatten.dmk.lab>
In-Reply-To: <20110802085447.GA4522@shale.localdomain>
References: <20110722192722.GA9369@x61.home>
	<20110802085447.GA4522@shale.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 11:54:47 +0300
Dan Carpenter <error27@gmail.com> wrote:

> Looking at this, I noticed a memory corruption bug introduce in:
> ab22cbda6651d "[media] vp7045: get rid of on-stack dma buffers"
> 
> vp7045_properties.size_of_priv is sizeof(u8 *) so in vp7045_usb_probe()
> the d->priv buffer gets allocated twice.  Once in:
> 	dvb_usb_device_init()
> 	-> dvb_usb_init()
> 
> And once explicitly to a larger buffer later on in the function with
> a kmalloc().
> 
> So the two places that use the buffer will probably race and cause
> memory corruption.
> 
> regards,
> dan carpenter

Damn. That (u8*)sized priv buffer should only hold a pointer to the
transfer buffer allocated in the prope routine. But I botched that. 
I will send a fixup in a minute.  

Regards,
Flo
