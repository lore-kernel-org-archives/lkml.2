Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1K0NYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 08:24:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43306 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1K0NYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 08:24:05 -0500
MIME-Version: 1.0
In-Reply-To: <jatcd7$4sc$1@ID-44327.news.uni-berlin.de>
References: <jatcd7$4sc$1@ID-44327.news.uni-berlin.de>
Date: Sun, 27 Nov 2011 14:24:03 +0100
Message-ID: <CAFLxGvzwbLZrECWRzDxbHMt+SwKyCUukh9=PEpEQZsw=EtgoJw@mail.gmail.com>
Subject: Re: Broken hd or filesystem access after resume from suspend2disk
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 2:02 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Hello,
>
> I'm often having trouble accessing the hd / filesystem after a resume
> from  suspend2disk. Sometimes, the machine completely hangs after resume
> or it cannot be suspended at all.
>
> Today, I faced the following problem after resuming:
>
> Using wpa_supplicant failed with the message:
>
> wpa_supplicant -t -c /etc/wpa_supplicant/wpa_supplicant.conf -f
> /var/log/wpa_supplicant.log -Dnl80211 -iwlan0
> wpa_supplicant: symbol lookup error: /lib64/libssl.so.1.0.0: undefined
> symbol: RAND_add
>
>
> ldd `which wpa_supplicant`
>        linux-vdso.so.1 =>  (0x00007fffd84b9000)
>        libnl.so.1 => /lib64/libnl.so.1 (0x00007fe5ac0bd000)
>        libdl.so.2 => /lib64/libdl.so.2 (0x00007fe5abeb9000)
>        libssl.so.1.0.0 => /lib64/libssl.so.1.0.0 (0x00007fe5abc5d000)
>        libcrypto.so.1.0.0 => /lib64/libcrypto.so.1.0.0 (0x00007fe5ab8ad000)
>        libdbus-1.so.3 => /lib64/libdbus-1.so.3 (0x00007fe5ab668000)
>        libc.so.6 => /lib64/libc.so.6 (0x00007fe5ab2d9000)
>        libm.so.6 => /lib64/libm.so.6 (0x00007fe5ab082000)
>        /lib64/ld-linux-x86-64.so.2 (0x00007fe5ac30f000)
>        libz.so.1 => /lib64/libz.so.1 (0x00007fe5aae6a000)
>        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fe5aac4d000)
>        librt.so.1 => /lib64/librt.so.1 (0x00007fe5aaa45000)
>
>
> rpm -qVf /lib64/libssl.so.1.0.0
> 5........    /lib64/libcrypto.so.1.0.0
>
> -> The libcrypto-library seems to be broken.
>
> In order to check, if there are more broken libraries (after the
> resume), I did a md5sum on the complete /lib64 directory to have it at
> base for a recheck after a reboot.
>
> The recheck after the reboot showed two more broken files:
>
> cd /lib64
> md5sum -c md5sum.out | grep FAILED
> libcrypto.so.1.0.0: FAILED
> libkeyutils.so.1: FAILED
> libkeyutils.so.1.4: FAILED
> md5sum: WARNING: 3 computed checksums did NOT match
>
> Apparently, there is something completely broken after resume.
>
>
> The machine is a MSI CR620 notebook and kernel is 3.1.
>
> 00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller
> (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation Core Processor
> Integrated Graphics Controller (rev 02)
> 00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series
> Chipset HECI Controller (rev 06)
> 00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 05)
> 00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
> High Definition Audio (rev 05)
> 00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 1 (rev 05)
> 00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 2 (rev 05)
> 00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 4 (rev 05)
> 00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 6 (rev 05)
> 00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 05)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
> 00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC
> Interface Controller (rev 05)
> 00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset
> 4 port SATA AHCI Controller (rev 05)
> 00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus
> Controller (rev 05)
> 00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400
> Series Chipset Thermal Subsystem (rev 05)
> 05:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless
> Network Adapter (PCI-Express) (rev 01)
> 06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
> 3f:00.0 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture Generic Non-core Registers (rev 02)
> 3f:00.1 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture System Address Decoder (rev 02)
> 3f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
> 3f:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0
> (rev 02)
> 3f:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
> 3f:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
>
>
> Does anybody has an idea how to fix / or further analyze this problem?
>

Hmmm, maybe this related to my problem:
http://thread.gmane.org/gmane.linux.kernel/1116939/focus=1117113

First I thought the issue is no longer present in newer kernels.
But my netbook still suffers on it.


-- 
Thanks,
//richard
