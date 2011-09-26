Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab1IZHxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:53:45 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:44726 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1IZHxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:53:44 -0400
Message-ID: <4E802F7D.9000006@parrot.com>
Date: Mon, 26 Sep 2011 09:53:33 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Simon Glass <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
References: <1316818998-30711-1-git-send-email-sjg@chromium.org> <20110924083203.GZ17169@n2100.arm.linux.org.uk>
In-Reply-To: <20110924083203.GZ17169@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Russell King - ARM Linux a écrit :
> On Fri, Sep 23, 2011 at 04:03:15PM -0700, Simon Glass wrote:
>> An accurate timer is required to make the numbers meaningful. Many
>> modern platforms have a microsecond timer. This patch set uses a
>> function called timer_get_us() to read the timer.
> 
> Not another 'get a time value' function.  Why do we need soo many?
> We have - at least:
> 
> ktime_get (and various flavours of it)
> do_gettimeofday
> getnstimeofday
> sched_clock
> 
> Do we really need yet another one which will have to be multiplexed
> amongst platforms, requiring scaling and so forth from whatever the
> platform provides?
> 
> Remember that ARM timers are virtually all MMIO mapped, which means
> they don't work during early kernel bringup when the MMU mappings for
> the hardware have not been setup.  (That's the reason stuff like
> sched_clock for printk doesn't work early.)
Doesn't cortexA-8 (and A9 ?) have a cycle counter that can be read by
coprocessor 15 ?

Couldn't we use that counter for early stuff on those architectures ?


Matthieu
