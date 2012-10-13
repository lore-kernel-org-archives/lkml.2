Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2JMJyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:54:19 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45780 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2JMJyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:54:17 -0400
Message-ID: <50793A47.7060705@kernel.org>
Date: Sat, 13 Oct 2012 10:54:15 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 07/12] staging/iio/lis3l02dq: fix building without irq_to_gpio
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-8-git-send-email-arnd@arndb.de> <5066C71E.9030302@kernel.org> <201209291503.40519.arnd@arndb.de>
In-Reply-To: <201209291503.40519.arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2012 04:03 PM, Arnd Bergmann wrote:
> On Saturday 29 September 2012, Jonathan Cameron wrote:
>> On 09/28/2012 10:36 PM, Arnd Bergmann wrote:
>>> The driver has not been building for some time after the
>>> irq_to_gpio function has been removed from the kernel.
>>>
>>> The only board in the upstream kernel that provides
>>> this device is the "Stargate 2", which is also maintained
>>> by Jonathan Cameron. Rather than working around the problem
>>> by adding new platform data for this driver, this patch
>>> uses the of_gpio framework to get to the gpio number.
>>>
>>> However, the stargate2 code does not (yet) use DT based
>>> probing, so it is still broken, but at least building
>>> allyesconfig works again.
>> Will be optimistic to think anyone will convert a platform
>> that no one still makes (stargate 2 was pretty much intel
>> research only + some they gave to accademics - imote2 has
>> been dropped by memsic for a while now.)  If nothing else
>> there is little chance anyone will bother porting a remotely
>> up to date bootloader to these boards given how few people
>> are still using them for anything.
> 
> The way are converting most ARM platforms to DT, we should be
> able to replace the board files with .dts files once all
> device drivers have been converted over. This is taking a
> bit longer for mmp/pxa than for some of the other platforms,
> Updating the boot loader makes it easier to deploy a DT
> version, but you can also append a DT blob to the kernel
> if that's not possible, and we will in the future allow
> appending multiple DT blobs and let the early boot stages
> pick the right one based on the board ID.
Sounds good.

> 
>> I'm happy enough with this patch.  Would prefer to
>> take it post merge window as a fix than now given timing.
> 
> Ok, fair enough. It has been broken for a while, so there
> is no hurry now. I just stumbled over it when doing an
> "allyesconfig" build.
Added to togreg branch of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

> 
>> Long run this driver will hopefully get replaced by the
>> unified driver for all the st accelerometers (assuming that
>> ever gets back to this long obsolete part).
> 
> Ok.
> 
> 	Arnd
> 
