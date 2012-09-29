Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2I2PDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 11:03:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60077 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2I2PDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 11:03:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 07/12] staging/iio/lis3l02dq: fix building without irq_to_gpio
Date: Sat, 29 Sep 2012 15:03:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, "Lars-Peter Clausen" <lars@metafoo.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-8-git-send-email-arnd@arndb.de> <5066C71E.9030302@kernel.org>
In-Reply-To: <5066C71E.9030302@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209291503.40519.arnd@arndb.de>
X-Provags-ID: V02:K0:gs9uU0bVr3VVY9F1er5AAIHSs0xgfA+LJtOKRY/5icx
 4F/8+LJIhibmMrDiDcuH/M3oMPxbXe0VD7wYvJ3E96vR7uBlAO
 1onjff0DyHTYVvrxSQGZ4shgmePVfFAazuRt1ffDQl+isjZC1K
 5GMKWdZu6B/kqQGnzoxaM7ZJwhYgDYqJh9rdzPL5Mo/0VlqAq2
 LEtP9sb0zfG0/5pFsEraMSqgp+vmKpcXjSMr3/B05Z5Cfv+th6
 4iuw950CVSAeetLsFIfyO1gcgOmJDd5B5iQaJFTF7fHhgN9cGN
 G2DetrE9uaJrnhoBX1fxiYEHrcRXJu/zG2t3ULGVg5+hKRIjmB
 vvqWvDTVoRtvZtt4I890=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2012, Jonathan Cameron wrote:
> On 09/28/2012 10:36 PM, Arnd Bergmann wrote:
> > The driver has not been building for some time after the
> > irq_to_gpio function has been removed from the kernel.
> > 
> > The only board in the upstream kernel that provides
> > this device is the "Stargate 2", which is also maintained
> > by Jonathan Cameron. Rather than working around the problem
> > by adding new platform data for this driver, this patch
> > uses the of_gpio framework to get to the gpio number.
> > 
> > However, the stargate2 code does not (yet) use DT based
> > probing, so it is still broken, but at least building
> > allyesconfig works again.
> Will be optimistic to think anyone will convert a platform
> that no one still makes (stargate 2 was pretty much intel
> research only + some they gave to accademics - imote2 has
> been dropped by memsic for a while now.)  If nothing else
> there is little chance anyone will bother porting a remotely
> up to date bootloader to these boards given how few people
> are still using them for anything.

The way are converting most ARM platforms to DT, we should be
able to replace the board files with .dts files once all
device drivers have been converted over. This is taking a
bit longer for mmp/pxa than for some of the other platforms,
Updating the boot loader makes it easier to deploy a DT
version, but you can also append a DT blob to the kernel
if that's not possible, and we will in the future allow
appending multiple DT blobs and let the early boot stages
pick the right one based on the board ID.

> I'm happy enough with this patch.  Would prefer to
> take it post merge window as a fix than now given timing.

Ok, fair enough. It has been broken for a while, so there
is no hurry now. I just stumbled over it when doing an
"allyesconfig" build.

> Long run this driver will hopefully get replaced by the
> unified driver for all the st accelerometers (assuming that
> ever gets back to this long obsolete part).

Ok.

	Arnd
