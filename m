Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab1IILvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:51:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60649 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab1IILvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:51:01 -0400
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: david.wagner@free-electrons.com, linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Fri, 09 Sep 2011 14:53:20 +0300
In-Reply-To: <201109081726.00769.arnd@arndb.de>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1315280704.19067.14.camel@sauron> <1315282208.19067.24.camel@sauron>
	 <201109081726.00769.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315569206.7905.41.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 17:26 +0200, Arnd Bergmann wrote:
> On Tuesday 06 September 2011, Artem Bityutskiy wrote:
> > Not sure about the bus approach - David, could you take a look at it
> > please? If we can handle errors there - then we could indeed re-use the
> > UBI control device. We could even re-use the ioctl data structures for
> > UBI volumes creation/removal - we have plenty of space there reserved
> > for future extensions.
> 
> I would generally recommend using new ioctl commands. ioctl numbers
> are cheap, but complexity in data structures is not, because every
> user who wants to deal with the data structures has to understand
> them. Also, changing the ABI is always tricky since you have to
> provide backward and forwards compatibility with existing kernels
> and with existing user space.

Hmm, what do we do if ubiblk module is not loaded, and UBI would have
to return an error (because the block device cannot be created), how
will UBI know that ubiblk is not there? Any direct call to ubiblk from
UBI would be a direct dependency and would require ubiblk to be always
loaded, which is bad.

IOW, we need a blocking mechanism to call the upper layer's function
(ubiblk) from the lower layer (UBI) which can return an error, and which
allows to check if a ubiblk exists at all. Do we have such mechanism?

Actually the fact of invoking upper layers from lower makes me worry.

And yes, the "bus"<->"devices" model does not look suitable in our case.
We have more like hierarchy: ubiblk uses ubi which usese mtd device.

David, I am really busy and now, I suggest you to think about this. I'd
so far stick to the own ubiblk cdev approach, and would
analyse/prototype the approach of using UBI cdev for this. I provided
some concerns above. Also, think about race conditions like:

1. Someone

-- 
Best Regards,
Artem Bityutskiy

