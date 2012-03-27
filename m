Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2C0KX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:23:59 -0400
Received: from gold.linx.net ([195.66.232.40]:55191 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab2C0KX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:23:56 -0400
Message-ID: <4F719541.1090001@linx.net>
Date: Tue, 27 Mar 2012 11:24:01 +0100
From: Tony Vroon <tony@linx.net>
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120326 Thunderbird/11.0
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie> <4F70764F.7030409@linx.net> <20120326143250.GN4014@phenom.ffwll.local> <4F707F05.7000401@linx.net> <20120327100128.GF4276@phenom.ffwll.local> <4F719262.7090008@linx.net>
In-Reply-To: <4F719262.7090008@linx.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 27/03/12 11:11, Tony Vroon wrote:
> No DMAR complaints in dmesg yet; it would have crashed by now if
> the fault was present.

To confirm, it is stable.
So ppgtt + VT-d is problematic on:
00:02.0 VGA compatible controller [0300]: Intel Corporation 2nd
Generation Core Processor Family Integrated Graphics Controller
[8086:0126] (rev 09) (prog-if 00 [VGA controller])
	Subsystem: Fujitsu Limited. Device [10cf:15e9]
	Flags: bus master, fast devsel, latency 0, IRQ 42
	Memory at e0000000 (64-bit, non-prefetchable) [size=4M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 3000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 2
	Capabilities: [a4] PCI Advanced Features
	Kernel driver in use: i915

For the avoidance of doubt, it is a mobile Core i7 part:
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz
stepping	: 7
microcode	: 0x25

Prior to the crash, I see:
DRHD: handling fault status reg 3
DMAR:[DMA Write] Request device [00:02.0] fault addr 12806b000
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 3
DMAR:[DMA Write] Request device [00:02.0] fault addr 128183000
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 3
DMAR:[DMA Write] Request device [00:02.0] fault addr 4147562000
DMAR:[fault reason 05] PTE Write access is not set
DRHD: handling fault status reg 3
DMAR:[DMA Write] Request device [00:02.0] fault addr 4147562000
DMAR:[fault reason 05] PTE Write access is not set

So I believe a bisection should point at commit
e21af88d39796c907c38648c824be3d646ffbe35, but I am willing to run one
if you really feel there is more to it?

Regards,
- -- 
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9xlUEACgkQp5vW4rUFj5q9mACgkyyW7PNZ4/vne++JXDrESaE8
D4AAn1hzqKHoMlwDCWxI+TbVkzrEZfGj
=SBBH
-----END PGP SIGNATURE-----
