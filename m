Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1DSNCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:02:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60273 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab1DSNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:02:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Williams <john.williams@petalogix.com>
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
Date: Tue, 19 Apr 2011 15:02:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu> <20110419061121.GB5252@ponder.secretlab.ca> <BANLkTin0krYi+MqngSQ5n-752vDa_a8ZtA@mail.gmail.com>
In-Reply-To: <BANLkTin0krYi+MqngSQ5n-752vDa_a8ZtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191502.37396.arnd@arndb.de>
X-Provags-ID: V02:K0:Z1SMPFnmYQbIq0XuPFAn3n6vJMD+b0nzAWxaafkATlK
 OJNLBdQ4nRjEw2c9pNe+UVG8WJy6WlerPvP+k9B33Tbr67oWU6
 +yl/AVrR2gjCWwDET36BNqV13lKGGMaXzi1A0j95Nllt1/SMd2
 kt1vwAlDKS4v+G6g2+QTlYmh3uJps9XbaqvpWtsRVYFqYkf9KO
 k6oWUAQXoNFf98/do9wZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 April 2011, John Williams wrote:
> OK, so let's talk about this interface.  As I see it, it must be able
> to handle bind per-instance, not per compatibility.

Yes.

> For example, we make systems with multiple, identical timers.  One
> will be used as the system timer, the others need to be (optionally)
> bound to generic UIO.
> 
> Therefore, it's not OK to just do
> 
> echo "vendor,device" >> /sys/class/something/generic-uio/compatlist
> 
> or whatever, as this would bind all instances matching vendor,device.
> 
> So, the question I have is, how to handle bind per-instance?
> 
> I can accept that the generic-uio idea is permanently blocked, but
> please can we have some concrete suggestions on an approach that would
> be acceptable?

I think nobody has had a good idea so far, unfortunately. It would
be nice if you could research how libusb, vfio and qemu pci passthrough
work. Hopefully one of these uses a method that we can do here, too.

> > In the mean time, explicitly modifying the match table is an okay
> > compromise.
> 
> My mind is still boggling that in this day and age it could possibly
> be preferred to modify code, instead of a data structure.  However,
> clearly this is a lost cause!

It's preferred to do a local modification to a single kernel build over
introducing an interface that we have to maintain compatibility with
when we already know we don't want it.

	Arnd
