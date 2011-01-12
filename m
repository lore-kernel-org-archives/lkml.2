Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1ALQfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:35:04 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:42057 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab1ALQfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:35:01 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2011 11:35:01 EST
Message-ID: <4D2DD5F8.5000200@parrot.com>
Date: Wed, 12 Jan 2011 17:25:28 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rabin Vincent <rabin@rab.in>, Alexander Holler <holler@ahsoftware.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: ARM: relocation out of range (when loading a module)
References: <4D2B4CE4.9080309@ahsoftware.de>	<alpine.LFD.2.00.1101101722470.9794@xanadu.home>	<4D2BFA08.5030104@ahsoftware.de>	<AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com> <20110111155930.GH11039@n2100.arm.linux.org.uk>
In-Reply-To: <20110111155930.GH11039@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux a écrit :
> On Tue, Jan 11, 2011 at 09:16:38PM +0530, Rabin Vincent wrote:
>> It's possible to hack around this by placing the initramfs at the end of
>> the kernel image rather than at the beginning with the rest of the init
>> data.  Something like the below should work, although you should also
>> probably take care of alignment and also have this section freed when
>> the rest of the init data is freed.
> 
> You're then running into problems as _sdata.._edata is copied to RAM on
> XIP kernels, and you really don't want to waste time copying the
> initramfs to RAM.
> 
But in this case initramfs is after edata and before bss.
So where is the problem ?


Matthieu
