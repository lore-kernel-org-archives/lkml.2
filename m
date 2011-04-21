Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1DUOuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:50:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1DUOus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:50:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Arend van Spriel" <arend@broadcom.com>
Subject: Re: [PATCH] drivers: brcmaxi: provide amba axi functionality in separate module
Date: Thu, 21 Apr 2011 16:50:09 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "zajec5@gmail.com" <zajec5@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "George Kashperko" <george@znau.edu.ua>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Andy Botting" <andy@andybotting.com>, "Greg KH" <greg@kroah.com>,
        "Michael Buesch" <m@bues.ch>
References: <1303331669-31293-1-git-send-email-arend@broadcom.com> <201104211612.49805.arnd@arndb.de> <op.vuallvn63ri7v4@arend-laptop>
In-Reply-To: <op.vuallvn63ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201104211650.09213.arnd@arndb.de>
X-Provags-ID: V02:K0:c0TZncafeEvu6ROfYBg8R0lTKjWvip8RYG849VCjVC0
 joLgd+TGWJZcgxt6c38Ubw/woj7305MfW61q7yHi+8dNg0A+xV
 1ZM/hHXMunhIlEdihZ2g8SfKQGyyMrCGuzWg673+a3BR/yDxIQ
 0rS5Wz1McQ5739cq3571mW+tuhSPCuyqdnQCf7BhjngG/LRV3B
 topJOmgCcT+giqfpRm7pA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 April 2011, Arend van Spriel wrote:
> >
> > This list to me is a strong hint that the cores behind the AXI bridge
> > should normally be actual devices in Linux, i.e. the approach that
> > Rafał suggested.  The vast majority of these is something that in Linux
> > would be operated by a device driver. The exceptions that I can see
> > are CPU cores and bus bridges, both of which we typically also represent
> > as devices in the flattened device tree, even though they typically
> > don't have a Linux driver attached to them.
> 
> Fine. Your providing the kind of feedback I was looking for. The  
> OFDM_CORE_ID is also an exception.
> 
> So could a device driver claim multiple cores/devices to assure other  
> drivers are not accessing those? I would prefer that over having  
> exceptions coded in the axi bus driver, like the chipcommon core  
> (CC_CORE_ID). I assume it can be done by the device table. Is that correct?

You can bind any number of devices to one driver, and the match table
can contain entries for different classes of devices. You can also
have multiple drivers list the same ID and return an error from the
probe() function for those devices that don't actually match the
driver, based on additional properties. E.g you could have multiple
ethernet drivers bind to ENET_CORE_ID, but then have each one check
if the ethernet hardware is actually the one that the driver was written
for.

A much harder thing to do would be having one device managed by multiple
drivers simultaneously. This usually requires to have some kind of abstraction
driver that provides interfaces to other drivers, or something like MFD that creates
devices as children of the main device, and lets those be bound to individual
drivers.

	Arnd
