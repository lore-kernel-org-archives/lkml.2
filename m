Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0DOJrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:47:46 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:58874 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab0DOJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:47:44 -0400
X-Spam-Flag: NO
X-Spam-Score: -24.389
Message-ID: <4BC6E0BC.2040006@tremplin-utc.net>
Date: Thu, 15 Apr 2010 11:47:40 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100331 Mandriva/3.0.4-1mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Daniel Mack <daniel@caiaq.de>, Alan Cox <alan@linux.intel.com>,
       linux-i2c@vger.kernel.org, khali@linux-fr.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: Re: [PATCH 3/4] liss331d1: accelerometer driver
References: <20100414124913.23181.75903.stgit@localhost.localdomain>	<20100414125155.23181.56610.stgit@localhost.localdomain>	<4BC63DC5.8040501@tudelft.nl>	<20100414223429.GW30807@buzzloop.caiaq.de> <20100415090542.21f9778d@notabene.brown>
In-Reply-To: <20100415090542.21f9778d@notabene.brown>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/10 01:05, Neil Brown wrote:
:
> 
> The Openmoko Freerunner has as lis302D which is an SPI version of a very
> similar device, so making the one driver work on that was well would be nice
> if possible.
Definitely!

> 
> The lis302d can detect threshold crossings and taps as well as simple
> orientation and I found it useful to include support for those in the driver
> as well.
> In particular:
>  1/ I allowed the 'data_rate' that was programmed to be any number (including 
>     fractions and 0) and the driver would report at that rate, using a timer
>     for rates below 50Hz.
>     When the app is only interested in long-term change, this can
>     significantly reduce the amount of data that has to be handled by
>     userspace.
Samu (from Nokia) has started to had such idea via the patch
lis3-setup-poll-interval-limits.patch which in now in the -mm tree. It
allows to specify the polling rate via the input interface
(/sys/devices/platform/lis3lv02d/input/input8/poll). But for now I don't
think the actual refresh rate is updated automatically, it would be a
nice addition.


> 
>  2/ I allowed a 'threshold' to be set so that changes bigger than that get
>     notified promptly even if that is faster than the requested data rate
It could be interesting too... but what interface are you using for the
userspace to specify this threshold? A sysfs file?

> 
>  3/ I allowed taps to be detected and reported as BTN_X BTN_Y and BTN_Z
>     input events.
This one should now be working with Samu's patch
lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch also in
the -mm tree.

> 
> Would it be sensible to include that support in this driver?  The
> LIS331DL seem to have the same threshold and tap support.
So all in all, if you could have a look at what changes are necessary to
get the lis3lv02d driver work with your hardware, it would be great. (I
suspect it should be quite little.)

See you,
Eric
