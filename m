Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab2IXQm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:42:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45899 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab2IXQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:42:57 -0400
Message-ID: <50608D8D.4060506@wwwdotorg.org>
Date: Mon, 24 Sep 2012 10:42:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, Chris Boot <bootc@bootc.net>,
        Dom Cobley <popcornmix@gmail.com>, Dom Cobley <dc4@broadcom.com>
Subject: Re: linux-next: Tree for Sept 24 (irqchip)
References: <20120925005328.f748dfa3d077cebb345a4291@canb.auug.org.au> <50607E99.6040303@xenotime.net> <20120925020744.cc5beb9e65473605e5ca2240@canb.auug.org.au>
In-Reply-To: <20120925020744.cc5beb9e65473605e5ca2240@canb.auug.org.au>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 10:07 AM, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Mon, 24 Sep 2012 08:39:05 -0700 Randy Dunlap
> <rdunlap@xenotime.net> wrote:
>> 
>> On 09/24/2012 07:53 AM, Stephen Rothwell wrote:
>> 
>>> Today was a train wreck, with lots of new conflicts across
>>> several trees and a few build failures as well.
>> 
>> I agree.  I mostly get this:
>> 
>> drivers/Kconfig:157: can't open file "drivers/irqchip/Kconfig"
>> 
>> i.e., no such file.
>> 
>> How does this happen?  :(
>> 
>> who handles irqchip?
> 
> Hmm, commit 89214f009c1d ("ARM: bcm2835: add interrupt controller 
> driver") from the arm-soc tree adds that file as an empty file (I
> have the empty file in my tree).  Nothing adds anything to it.

That's odd. I just checked out next-20120924, and that (empty) file
does appear on my disk as expected. Do some versions of git not handle
creating empty files?

Note that IIRC the Kconfig file is required, because otherwise the
build process won't recurse into drivers/irqchip/ and hence code won't
be linked into the kernel image.

The file is empty because the Makefile there keys of
CONFIG_ARCH_BCM2835 and hence doesn't need drivers/irqchip/Kconfig to
define any new Kconfig variables.
