Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0CZXrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:47:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39501 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab0CZXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:47:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BAD4795.2040700@s5r6.in-berlin.de>
Date: Sat, 27 Mar 2010 00:47:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
References: <201003242240.54907.arnd@arndb.de> <alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz> <201003251406.10177.arnd@arndb.de> <201003251438.59062.arnd@arndb.de>
In-Reply-To: <201003251438.59062.arnd@arndb.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 25 March 2010, Arnd Bergmann wrote:
>> On Thursday 25 March 2010, Jiri Kosina wrote:
>>>         config USB
>>>                 tristate "Support for Host-side USB"
>>>                 depends on USB_ARCH_HAS_HCD && BKL
>>>
>>> Well, that's very interesting definition of "obscure" :)
>>>
>> That's why I said /mostly/ obscure modules. There are soundcore, usb-core, drm,
>> vfat and a few other very common ones, along with many obscure ones.
> 
> FWIW, this is the full list of 148 modules that require the BKL in an x86 allmodconfig,
> which is probably the configuration with the largest code coverage.
...
> drivers/media/dvb/firewire/firedtv.ko
...
> drivers/ieee1394/video1394.ko
> drivers/ieee1394/raw1394.ko
> drivers/ieee1394/dv1394.ko
...
> drivers/firewire/firewire-core.ko

firewire-core and raw1394 do not actually require the BKL, they only
miss to declare their files as not seekable.  I will post patches which
change these accordingly.

My guess is that there is nothing to seek in dv1394, video1394, and
firedtv either.

Needless to say, there may be other character device file interfaces
which cannot be seeked but don't admit it yet.
-- 
Stefan Richter
-=====-==-=- --== ==-==
http://arcgraph.de/sr/
