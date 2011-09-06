Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1IFIjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:39:53 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:32782 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1IFIjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:39:49 -0400
MIME-Version: 1.0
In-Reply-To: <1315290313.2565.0.camel@edumazet-laptop>
References: <CAAJw_Zv9LaOut6+aQWki_-nCngEEfh-OVqF4rsUwb-LPfLk8Ug@mail.gmail.com>
	<CAAJw_ZvP6m=3T0YoYq6VJdOKMxzm3fDcdJoDY8wqqDV8GZB+Dg@mail.gmail.com>
	<1315290313.2565.0.camel@edumazet-laptop>
Date: Tue, 6 Sep 2011 16:39:48 +0800
Message-ID: <CAAJw_ZvTX374XDZEi_rFAL=797au_7J9gfuDVz-h9o-+Zp_f4w@mail.gmail.com>
Subject: Re: linux-3.1-0-rc4 bus error ... MPS configured higher than maximum
 supported by the device. If a bus issue occurs, try running with pci=pcie_bus_safe.
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jordan_Hargrave@dell.com,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 2:25 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 06 septembre 2011 à 14:09 +0800, Jeff Chua a écrit :
>> On Mon, Sep 5, 2011 at 10:55 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> > Got the following error after upgrading from linux-2.6.36 to
>> > linux-3.1.0-rc4 on a Dell PowerEdge 2950 that has a PCIe fax card, and
>> > the system LED panel shows "Bus Fatal Error".
>> >
>> >
>> > Is is normal or should I try out "pci=pcie_bus_safe" or "pci=pci" as
>> > suggested in the dmesg?
>> >
>> > There was another error that also showed up on 2.6.36 but I'm ignoring
>> > that for now ( ... disabling ASPM on pre-1.1 PCIe device.  You can
>> > enable it with 'pcie_aspm=force')
>> >
>> > pci 0000:07:00.0: Dev MPS 128 MPSS 256 MRRS 4096
>> > pci 0000:07:00.0: Dev MPS 256 MPSS 256 MRRS 128
>> > pci 0000:08:00.0: Dev MPS 128 MPSS 128 MRRS 128
>> > pci 0000:08:00.0: MPS configured higher than maximum supported by the
>> > device.  If a bus issue occurs, try running with pci=pcie_bus_safe.
>> > pci 0000:08:00.0: Dev MPS 256 MPSS 256 MRRS 128
>> > Uhhuh. NMI received for unknown reason 31 on CPU 0.
>> > Do you have a strange power saving mode enabled?
>> > Dazed and confused, but trying to continue
>> > pci 0000:07:01.0: Dev MPS 128 MPSS 256 MRRS 4096
>> > pci 0000:07:01.0: Dev MPS 256 MPSS 256 MRRS 128
>> > pci 0000:00:06.0: Dev MPS 256 MPSS 256 MRRS 128
>> > pci 0000:0e:00.0: Dev MPS 128 MPSS 128 MRRS 512
>> > pci 0000:0e:00.0: MPS configured higher than maximum supported by the
>> > device.  If a bus issue occurs, try running with pci=pci
>>
>> The above aspm and bus error went away after I added pcie_aspm=force
>> and pci=pcie_bus_safe.
>>
>> Instead of default to pcie_bus_perf that caused problems, why not
>> default to the formal behavior (see commit
>> b03e7495a862b028294f59fc87286d6d78ee7fa1).
>
> I believe a revert is in progress anyway, see my other thread (scsi:
> hpsa: how to destroy your files)

Eric,

Thanks. I saw that. And the system nearly got trashed even though I've
no hpsa. Grub went into rescue mode after reboot, and I had to rebuild
the grub boot sector.

Now, it's all ok with pcie_aspm=force and pci=pcie_bus_safe.

Thanks,
Jeff
