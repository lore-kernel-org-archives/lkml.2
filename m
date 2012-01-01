Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2AAJyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 04:54:53 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63315 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2AAJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 04:54:50 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Sun, 1 Jan 2012 10:54:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Matthew Garrett <mjg@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <20111230235421.GA6054@redhat.com> <201112311939.19170.marek.vasut@gmail.com> <201201011048.18953.oliver@neukum.org>
In-Reply-To: <201201011048.18953.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201011054.47233.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Am Samstag, 31. Dezember 2011, 19:39:18 schrieb Marek Vasut:
> > maybe we should implement such thing into the firmware loader itself?
> > Allow it -- for example via some node in /dev -- to force loading
> > firmware into some buffer in kernel just before suspend so it'll
> > certainly be readily available at resume time?
> 
> This is difficult. We don't know at suspend time which firmware we will
> need at resume time.

That's not actually true ... you can ask the drivers if they need to load 
firmware after resume ... that can be implemented and udev can handle it. The 
driver should know if the hardware it's controlling is stupid or not.

> We could keep a record of firmware we needed
> to get to the state we are, but this is a very complex scheme.

Not really. You might have a device where you load firmware, issue suspend 
command and then issue resume command, while the device will still retain 
firmware in it, it'll be only in low power mode throughout the sleep cycle.

Then you can have a device that will just power down completely, wiping the 
firmware from it's memory. And that's what should be taken care of by injecting 
the firmware before suspend. The driver should be able to tell you if the device 
is broken and needs this special treatment.

This will though delay the time to suspect slightly, but that can be considered 
a price you have to pay if your hardware is stupid.

M
> 
> 	Regards
> 		Oliver
