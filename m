Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab0FBXcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:32:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46784 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204Ab0FBXcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nhz2XljhnY0R12slMIpTKeUikfAC3vqmGY7qeWTb6aT7OZzI2P8jmcnIgfAELlEIp8
         nBnxR4MTtnclQ2IonHxQZ1E3tQ5kVOc1bCRZUMaOHtCObtkWFT3oWiQ8pUCEpO670+E1
         gRs/StdSdTaT8nPBJOioDV3bDdV6jZUMce2eI=
Date: Wed, 2 Jun 2010 16:32:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Neil Brown <neilb@suse.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] - race-free suspend. Was: Re: [linux-pm] [PATCH 0/8]
 Suspend block api (version 8)
Message-ID: <20100602233243.GA27666@core.coreip.homeip.net>
References: <20100601113309.609349fd@notabene.brown>
 <alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
 <20100601122012.1edeaf48@notabene.brown>
 <alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
 <20100602153235.340a7852@notabene.brown>
 <AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
 <20100602180614.729246ea@notabene.brown>
 <AANLkTimISbs4X2YR_Pal9A80mpkNyCy8laWBcOgR2Cl7@mail.gmail.com>
 <20100602210224.6ae2333f@notabene.brown>
 <20100602210521.54b9cd9b@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602210521.54b9cd9b@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:05:21PM +0200, Florian Mickler wrote:
> On Wed, 2 Jun 2010 21:02:24 +1000
> Neil Brown <neilb@suse.de> wrote:
> > 
> > And this decision (to block suspend) really needs to be made in the driver,
> > not in userspace?
> 
> Well, it fits. The requirement is a direct consequence of the intimate
> knowledge the driver has about the driven devices.

That is not really true. A driver does have intimate knowledge of the
device, however it does not necessarily have an idea about the data read
from the device. Consider the gpio_matrix driver: Arve says that it has
to continue scanning matrix once first interrupt arrvies. But it really
depends on what key has been pressed - if user pressed KEY_SUSPEND or
KEY_POWER it cmight be better if we did not wait for key release but
initiated the action right away. The decision on how system reacts to a
key press does not belong to the driver but really to userspace.
 
-- 
Dmitry
