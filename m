Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2D3V3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:29:14 -0400
Received: from 2481.rev.megiteam.pl ([91.227.36.129]:57939 "EHLO
	vk1001.megiteam.com.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab2D3V3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:29:13 -0400
Message-ID: <4F9F0426.6040603@localdomain.pl>
Date: Mon, 30 Apr 2012 23:29:10 +0200
From: Grzegorz Nosek <root@localdomain.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        support@supermicro.com
Subject: Re: EHCI software retries break Supermicro IPKVM
References: <Pine.LNX.4.44L0.1204301707060.1558-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1204301707060.1558-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 30.04.2012 23:12, Alan Stern pisze:
> It isn't a software issue.  You've got a hardware problem; either the
> IPKVM itself, or the connecting cable, or your computer's EHCI
> controller is bad.  The only reason the device worked without the retry
> logic is because it failed so completely that the kernel was forced to
> run it at full speed (12 Mb/s) instead of high speed (480 Mb/s).  With
> the retry logic present, the device was barely workable at high speed
> (but it probably didn't work well enough to be very useful).

Oh. Thanks for the info. Is there a way to force the device into 12Mb/s 
mode? I don't care about performance as the bottleneck is my Internet 
link on the client, anyway. The retry logic rendered the console 
unusable (not just slow, completely no keyboard or redirected media).

> Have you tried plugging the IPKVM into a different computer to see if
> it behaves any better?

Nope. The IPKVM is a proprietary addon card without any cables (plugs 
into a dedicated slot on the motherboard). Another identical machine is 
misbehaving the exact same way (retry messages in dmesg), so either I'm 
just unlucky, or it's a wider issue. Still, a few others are working 
fine (no retry messages; though I did not check the KVM recently). All 
the machines are in a rather remote DC, so I'm unlikely to muck with the 
hardware any time soon.

Are there any diagnostics possible to determine what is broken (i.e. the 
KVM card or the controller)? IIRC plugging a physical USB-based KVM 
worked fine, although that might have been an older kernel, without the 
retry logic.

Best regards,
  Grzegorz Nosek
