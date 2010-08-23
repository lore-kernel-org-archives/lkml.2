Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0HWUtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:49:40 -0400
Received: from pop-altamira.atl.sa.earthlink.net ([207.69.195.62]:64023 "EHLO
	pop-altamira.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968Ab0HWUtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:49:36 -0400
Date: Mon, 23 Aug 2010 16:49:32 -0400 (EDT)
From: Mark Whitis <whitis@freelabs.com>
X-X-Sender: whitis@cervantes
To: linux-kernel@vger.kernel.org
Subject: Re: usbtmc makes Rigol DS1052E oscilloscope crash
In-Reply-To: <alpine.DEB.2.00.1007290906210.25904@cervantes>
Message-ID: <alpine.DEB.2.00.1008231624260.19912@cervantes>
References: <alpine.DEB.2.00.1007290906210.25904@cervantes>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 29 Jul 2010, Mark Whitis wrote:

> On my system, I have a similar problem but with somewhat different symptoms.
>
> I only get 2018 bytes back, whether the scope sends 8192 or 524288 bytes. 
> 610 bytes and 1210 bytes read ok.
>
> ...

Another data point: 
The author of one libusb based driver for this scope, after corresponding 
with rigol, found it necessary to limit the first usb read from the bulk 
endpoint to 64 bytes.   After that continuation requests were allowed to 
be full size.    It is possible this is what is causing the symptoms, 
though it is a bit odd that the error doesn't show up until 2K later.

If this is the source of the problem (and if it isn't, it is apparently 
still the source of other problems), it could be worked around by having 
an IOCTL to limit the size of the first low level read and to optionally 
limit the sizes of other reads   This can't be fixed at the application level by changing the size passed to read() 
because of the nature of the usbtmc api in which read() returns entire 
messages rather than being stream oriented.

The DS1052E uses the same firmware as some other models.    The company 
makes other test equipment that may share the offending code and knockoffs 
of older models are sold under a couple brand names.   Thus the number of 
devices which might be affected could be in the dozens.    Other unrelated 
devices may also have similar problems with USBs very limiting timing 
constraints.    The DS1052E, in particular, is popular with linux users 
due to its price/performance ratio, its hackability, and the fact that 
more technical info and discussion has been posted on forums than for 
other DSOs. Thus, incorporating some defensive programming into the 
usbtmc driver would seem warranted.

