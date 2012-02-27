Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2B0BF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 20:05:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59181 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2B0BFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 20:05:52 -0500
MIME-Version: 1.0
In-Reply-To: <1329964013.18070.3.camel@minggr>
References: <4F415775.7060003@suse.cz>
	<20120219211709.GA30809@homac.suse.de>
	<1329726646.3368.2.camel@minggr>
	<4F42420E.2010301@suse.cz>
	<1329964013.18070.3.camel@minggr>
Date: Mon, 27 Feb 2012 09:05:51 +0800
X-Google-Sender-Auth: O-dIIlfwHibrvbQnKKaAFu4PfzQ
Message-ID: <CAF1ivSaQU1MXbExbtRkXy5YcbymCM_9DdR9d4BqMbti2rbvehg@mail.gmail.com>
Subject: Re: ahci: sata hotplug doesn't work after suspend
From: Lin Ming <ming.m.lin@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Holger Macht <holger@homac.de>, Jiri Slaby <jirislaby@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 10:26 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Mon, 2012-02-20 at 13:52 +0100, Jiri Slaby wrote:
>> On 02/20/2012 09:30 AM, Lin Ming wrote:
>> > On Sun, 2012-02-19 at 22:17 +0100, Holger Macht wrote:
>> >> On So 19. Feb - 21:11:33, Jiri Slaby wrote:
>> >>> Hi,
>> >>>
>> >>> ahci hotplug stopped working here. It always worked (-next-20111206 is
>> >>> the last known working for sure). I'm using -next and after plugging a
>> >>> sata disk in, nothing happens. I don't *think* (in the traffic, it's
>> >>> hard to tell for sure) an interrupt is generated either. I also *think*
>> >>> that it works before suspend/resume, but not after. (Or maybe uptime
>> >>> matters?)
>> >>>
>> >>> This happens before suspend on plug-in:
>> >>> ata3: exception Emask 0x50 SAct 0x0 SErr 0x40d0800 action 0xe frozen
>> >>> ata3: irq_stat 0x00000040, connection status changed
>> >>> ata3: SError: { HostInt PHYRdyChg CommWake 10B8B DevExch }
>> >>> ata3: hard resetting link
>> >>> ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> >>> ata3.00: ATA-8: ST31000528AS, CC38, max UDMA/133
>> >>> ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> >>> ata3.00: configured for UDMA/133
>> >>> ata3: EH complete
>> >>> scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC38 PQ: 0 ANSI: 5
>> >>> sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>> >>> sd 2:0:0:0: [sdc] Write Protect is off
>> >>> sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>> >>> sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
>> >>> support DPO or FUA
>> >>>  sdc: sdc1 sdc2
>> >>> sd 2:0:0:0: [sdc] Attached SCSI disk
>> >>>
>> >>> After suspend/resume and plug-in, nothing appears in dmesg. Storing "- -
>> >>> -" to /sys/class/scsi_host/host*/scan doesn't help. It looks like the
>> >>> line is completely dead, because only ata1 and ata2 say "hard resetting
>> >>> link" after this (and another two disks are connected there).
>> >>>
>> >>> I tried 'echo adapter >host_reset', but I get 'write error: Invalid
>> >>> argument'.
>> >>>
>> >>> 00:1f.2 SATA controller [0106]: Intel Corporation 82801IR/IO/IH
>> >>> (ICH9R/DO/DH) 6 port SATA Controller [AHCI mode] [8086:2922] (rev 02)
>> >>> (prog-if 01 [AHCI 1.0])
>> >>>         Subsystem: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port
>> >>> SATA Controller [AHCI mode] [8086:2922]
>> >>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> >>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>> >>>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> >>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>> >>>         Latency: 0
>> >>>         Interrupt: pin B routed to IRQ 43
>> >>>         Region 0: I/O ports at cc00 [size=8]
>> >>>         Region 1: I/O ports at c880 [size=4]
>> >>>         Region 2: I/O ports at c800 [size=8]
>> >>>         Region 3: I/O ports at c480 [size=4]
>> >>>         Region 4: I/O ports at c400 [size=32]
>> >>>         Region 5: Memory at feb7c800 (32-bit, non-prefetchable) [size=2K]
>> >>>         Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
>> >>>                 Address: fee0100c  Data: 4171
>> >>>         Capabilities: [70] Power Management version 3
>> >>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> >>> PME(D0-,D1-,D2-,D3hot+,D3cold-)
>> >>>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>> >>>         Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
>> >>>         Capabilities: [b0] Vendor Specific Information: Len=06 <?>
>> >>>         Kernel driver in use: ahci
>> >>>
>> >>> Any ideas what that could be?
>> >>
>> >> I suspect this is caused by commit
>> >> 9ee4f3933930abf5cc34f8e9d69fe0e08c18f602. Maybe you could verify? I
>> >> bisected this a couple of days ago but didn't have time to look into it
>> >> further. Maybe Lin can help here if this is the problematic commit.
>> >
>> > I'll try to re-produce this issue first.
>>
>> Ok, just a few more information. Suspend/resume cycle is needed to see
>> the issue. Reverting of 9ee4f3933930 helps when this is applied too (I
>> haven't tried one or the other alone):
>
> For now, the simple fix is to disable runtime pm for hotpluggable port.
>
> Could you please try below patch?
>
> And please also show the debug info.
> dmesg |grep "DEBUG: port"

Hi Jiri,

Will you get a chance to test this patch?

Thanks,
Lin Ming

>
> From 28bf2f0592f231c2caba816428beaffc28873d8e Mon Sep 17 00:00:00 2001
> From: Lin Ming <ming.m.lin@intel.com>
> Date: Thu, 23 Feb 2012 10:21:18 +0800
> Subject: [PATCH] libata: disable runtime pm for hotpluggable port
>
> ---
>  drivers/ata/ahci.c             |    3 +++
>  drivers/ata/ahci.h             |    3 +++
>  drivers/ata/libahci.c          |   21 +++++++++++++++++++++
>  drivers/ata/libata-transport.c |    6 ++++--
>  include/linux/libata.h         |    4 +++-
>  5 files changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index d07bf03..02e93ff 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1145,6 +1145,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>        if (hpriv->cap & HOST_CAP_PMP)
>                pi.flags |= ATA_FLAG_PMP;
>
> +       if (hpriv->cap & HOST_CAP_SXS)
> +               pi.flags |= ATA_FLAG_EXTERNAL;
> +
>        ahci_set_em_messages(hpriv, &pi);
>
>        if (ahci_broken_system_poweroff(pdev)) {
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index b175000..92f7172 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -172,6 +172,9 @@ enum {
>        PORT_CMD_ALPE           = (1 << 26), /* Aggressive Link PM enable */
>        PORT_CMD_ATAPI          = (1 << 24), /* Device is ATAPI */
>        PORT_CMD_FBSCP          = (1 << 22), /* FBS Capable Port */
> +       PORT_CMD_ESP            = (1 << 21), /* External SATA Port */
> +       PORT_CMD_MPSP           = (1 << 19), /* Mechanical Presence Switch Attached to Port */
> +       PORT_CMD_HPCP           = (1 << 18), /* Hot Plug Capable Port */
>        PORT_CMD_PMP            = (1 << 17), /* PMP attached */
>        PORT_CMD_LIST_ON        = (1 << 15), /* cmd list DMA engine running */
>        PORT_CMD_FIS_ON         = (1 << 14), /* FIS DMA engine running */
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index a72bfd0..a0222e9 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -1097,6 +1097,24 @@ static void ahci_port_init(struct device *dev, struct ata_port *ap,
>        writel(1 << port_no, mmio + HOST_IRQ_STAT);
>  }
>
> +static bool ahci_port_pluggable(struct ata_port *ap)
> +{
> +       void __iomem *port_mmio = ahci_port_base(ap);
> +       u32 cmd;
> +
> +       cmd = readl(port_mmio + PORT_CMD);
> +       printk(KERN_ERR "DEBUG: port %d, PORT_CMD=0x%x\n", ap->port_no, cmd);
> +
> +       if ((ap->flags & ATA_FLAG_EXTERNAL) &&
> +           (cmd & PORT_CMD_ESP))
> +               return true;
> +
> +       if (cmd & (PORT_CMD_MPSP | PORT_CMD_HPCP))
> +               return true;
> +
> +       return false;
> +}
> +
>  void ahci_init_controller(struct ata_host *host)
>  {
>        struct ahci_host_priv *hpriv = host->private_data;
> @@ -1112,6 +1130,9 @@ void ahci_init_controller(struct ata_host *host)
>                if (ata_port_is_dummy(ap))
>                        continue;
>
> +               if (ahci_port_pluggable(ap))
> +                       ap->flags |= ATA_FLAG_PLUGGABLE;
> +
>                ahci_port_init(host->dev, ap, i, mmio, port_mmio);
>        }
>
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
> index 74aaee3..a7166b9 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -292,8 +292,10 @@ int ata_tport_add(struct device *parent,
>        }
>
>        device_enable_async_suspend(dev);
> -       pm_runtime_set_active(dev);
> -       pm_runtime_enable(dev);
> +       if (!(ap->flags & ATA_FLAG_PLUGGABLE)) {
> +               pm_runtime_set_active(dev);
> +               pm_runtime_enable(dev);
> +       }
>
>        transport_add_device(dev);
>        transport_configure_device(dev);
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index cafc09a..e8221cf 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -207,8 +207,10 @@ enum {
>        ATA_FLAG_SW_ACTIVITY    = (1 << 22), /* driver supports sw activity
>                                              * led */
>        ATA_FLAG_NO_DIPM        = (1 << 23), /* host not happy with DIPM */
> +       ATA_FLAG_EXTERNAL       = (1 << 24), /* controller supports external SATA */
> +       ATA_FLAG_PLUGGABLE      = (1 << 25), /* port is hotpluggable */
>
> -       /* bits 24:31 of ap->flags are reserved for LLD specific flags */
> +       /* bits 26:31 of ap->flags are reserved for LLD specific flags */
>
>
>        /* struct ata_port pflags */
> --
> 1.7.9
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
