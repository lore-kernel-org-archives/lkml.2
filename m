Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1K2LoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:44:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab1K2LoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:44:17 -0500
Date: Tue, 29 Nov 2011 12:46:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] Poor performance and lockup with rt2800usb and
 Asus USB-N13 adapter
Message-ID: <20111129114603.GB7299@redhat.com>
References: <4ED43A5C.9000102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED43A5C.9000102@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 07:50:20PM -0600, Robert Hancock wrote:
> I recently got an Asus USB-N13 USB Wireless-N adapter which
> apparently uses a Ralink RT3072 chip. I'm using it with an Asus
> RT-N16 access point running TomatoUSB. When running Windows the
> performance is reasonable (about 80 Mbps in both directions).
> However under Fedora 16 (currently kernel 3.1.2) the performance is
> abysmal (10 Mbps or less with lots of packet loss). I'll post some
> debug information below.
rt2800usb needs fixing. I'm able to reproduce these performance
problems locally. They are quite hard to debug, and need some
experiments. But I hope I will provide patches soon or leter.

> While debugging this I also noticed that doing an rmmod on rt2800usb
> with the adapter plugged in locks up the machine and then spews out
> soft lockup stack traces on the console. I was only able to capture
> it off the screen with a camera, but it basically is:
> 
> rt2x00usb_work_rxdone
> process_one_work
> worker_thread
> kthread
> kernel_thread_helper
Another thing to investigate. Can yo try to reproduce that with
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
and see if these options print some aditional message when rmmod.

Thanks
Stanislaw
