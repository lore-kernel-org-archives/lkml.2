Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab0HQJ03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:26:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50613 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab0HQJ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:26:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Date: Tue, 17 Aug 2010 09:25:55 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.35-8-generic; KDE/4.4.92; x86_64; ; )
Cc: linuxppc-dev@lists.ozlabs.org, Rodolfo Giometti <giometti@linux.it>,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Krzysztof Halasa <khc@pm.waw.pl>
References: <cover.1281956490.git.richard.cochran@omicron.at> <201008162159.39734.arnd@arndb.de> <20100817083216.GA3330@riccoc20.at.omicron.at>
In-Reply-To: <20100817083216.GA3330@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008170925.55592.arnd@arndb.de>
X-Provags-ID: V02:K0:SQv1ct0GXdRf17MFXQZHVgYdOqRCKuv6uboRqEVOz3G
 GkaLeiGTJUVYJJXvbB+kELbooLa/Xo4Nl4VkwtGlZE9rh/fNd9
 jLoi0dd+VOg4EcXB20MM7RWiXmRQi+5ig1ZuF/cSNJ1L706AER
 Gfi5wJDrAvvvyDeIxxO9dLEzMhjNir5njWVOqPYMN//8jfChqn
 +YwZh3MPU7dXTfCxidTEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010, Richard Cochran wrote:
> > Why did you not want to add syscalls? Adding ioctls instead of syscalls
> > does not make the interface better, just less visible.
> 
> I bet that, had I posted patch set with new syscalls, someone would
> have said, "You are adding new syscalls. Can't you just use a char
> device instead!"

Very possible, but after considering both options, I think we would
still end up with the same conclusion.
 
> If you add syscalls and introduce CLOCK_PTP, then you add it to
> everyone's kernel, even those people who never heard of PTP. A char
> device has the advantage that can it be simply ignored.

It's a matter of perspective whether you consider this an advantage
or disadvantage. I would expect that since you are trying to get support
for PTP into the kernel, you'd be happy for people to know about it and
use your code ;-).

> Also, a syscall has got to have the right form from the very beginning.
> If the next generation of PTP hardware looks very different, then it is not
> that much of a crime to change an ioctl interface, provided it has
> versioning.

No, that's just a myth. The rules for ABI stability are pretty much the
same. We try hard to avoid ever changing an existing ABI, for both
syscalls and ioctl. In either case, if you get it wrong, you have to support
the old interface and create a new syscall or ioctl command.
As mentioned, versioning does not solve this, it just adds another
indirection (which we try to avoid).

One difference is that more people take a look at your code when you suggest
a new syscall, so the chances of getting it right in the first upstream
version are higher.
Another difference is that we generally use ioctl for devices that can
be enumerated, while syscalls are for system services that are not tied to
a specific device. This argument works both ways for PTP IMHO: On the one
hand you want to have a reliable clock that you can use without knowing
where it comes from, on the other you might have multiple PTP sources that
you need to differentiate.

	Arnd
