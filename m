Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab0FTSEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 14:04:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51468 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab0FTSEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 14:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BilImvXUyjY3QLqQw5TOfKx5p7Qgm5WzlJqmgld0piDEv1navGGNuTk2DniluxiZkj
         3utl2yfrTmMSKxRUWjdjKRj14ldie8li+z0Fa9NcUG6eVtHobJ5Ptxj0EgMHsGk4B6HH
         YqTW8aRgFblDUTk7U7QOAQyBm/X4IhI4nBsC0=
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
In-Reply-To: <1277032723.9555.12.camel@maxim-laptop>
References: <20100528100901.14580.1322.stgit@fate.lan>
	 <1276806785.20754.8.camel@maxim-laptop>
	 <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	 <1276856142.9114.1.camel@maxim-laptop>
	 <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
	 <1276859156.19554.2.camel@maxim-laptop>
	 <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
	 <1276870309.23783.3.camel@maxim-laptop>
	 <1276933774.16697.11.camel@maxim-laptop>
	 <AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com>
	 <1277032723.9555.12.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Jun 2010 21:04:01 +0300
Message-ID: <1277057041.17953.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-20 at 14:18 +0300, Maxim Levitsky wrote: 
> On Sun, 2010-06-20 at 01:13 -0700, Luis R. Rodriguez wrote: 
> > Note: this e-mail is on a public mailing list.
> > 
> > On Sat, Jun 19, 2010 at 12:49 AM, Maxim Levitsky
> > <maximlevitsky@gmail.com> wrote:
> > > On Fri, 2010-06-18 at 17:11 +0300, Maxim Levitsky wrote:
> > >> On Fri, 2010-06-18 at 09:59 -0400, Bob Copeland wrote:
> > >> > On Fri, Jun 18, 2010 at 7:05 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > >> > >> Patch I made uses GPL code from e1000e, but since ath5k is
> > >> > >> dual-licensed so patch can't be accepted. So if I got it right, patch
> > >> > >> has to be remade from scratch by someone who really knows about pci
> > >> > >> registers etc. I don't, and learning this to fix something that is
> > >> > >> already fixed in my point of view is waste of (my) time.
> > >> > > Sure, regardless of licensing, this patch has to be redone (and e1000
> > >> > > with it)
> > >> >
> > >> > At any rate, Jussi, thanks a bundle for tracking it down.  I owe you a
> > >> > beer, lots of bugs have been reported on these devices.
> > >> >
> > >> > Maxim, this device was always broken in the same way, right?  Just
> > >> > curious if anything made it worse recently.
> > >>
> > >> Always was broken, of course even with madwifi.
> > >>
> > >> Recently I think driver stopped doing reset on RXORN, which sometimes
> > >> helped. This did made things a bit worse.
> > >>
> > >> Anyway, just disable L0S, and card works perfectly.
> > >
> > > How this patch?
> > > Its same patch but without open coded ASPM disabler.
> > > Of course to work therefore you need CONFIG_PCIEASPM.
> > > Without it, this reduces to noop.
> > > However I asked at linux-pci, and they said that its not a bad idea to
> > > just remove CONFIG_PCIEASPM and make it default.
> > >
> > > I hope there won't be a silly GPL vs BSD debate over one line of code...
> > 
> > When you use the SOB you respect the license of the file you are
> > editing, please see Documentation/SubmittingPatches Developer's
> > Certificate of Origin 1.1.
> This is ok of course.
> The debate was about Jussi Kivilinna copying ASPM disabler code from
> e1000 which is GPL.
> 
> > 
> > > commit ac5de416f822917b927958b21186a82141550da7
> > > Author: Maxim Levitsky <maximlevitsky@gmail.com>
> > > Date:   Thu Jun 17 23:21:42 2010 +0300
> > >
> > >    ath5k: disable ASPM
> > 
> > You are not disabling ASPM, you are disabling L0s. ASPM can work with
> > L1, for example.
> This is left over from original patch.
> with open coded code I was able to disable just L0s and get stable
> operation.
> Note however that with this patch which implies CONFIG_PCIEASPM, pci
> core disables both L0s and L1
> (I still need to test and see if I need that patch at all. Maybe just
> enabling CONFIG_PCIEASPM is enough...)
Yep, the patch isn't needed, because of this:

pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'


03:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network Adapter (rev 01)
	Subsystem: Foxconn International, Inc. Device e008
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at 55200000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
		Vector table: BAR=0 offset=00000000
		PBA: BAR=0 offset=00000000
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Kernel driver in use: ath5k
	Kernel modules: ath5k


static int pcie_aspm_sanity_check(struct pci_dev *pdev)
{
	struct pci_dev *child;
	int pos;
	u32 reg32;
	/*
	 * Some functions in a slot might not all be PCIe functions,
	 * very strange. Disable ASPM for the whole slot
	 */
	list_for_each_entry(child, &pdev->subordinate->devices, bus_list) {
		pos = pci_pcie_cap(child);
		if (!pos)
			return -EINVAL;
		/*
		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
		 * RBER bit to determine if a function is 1.1 version device
		 */
		pci_read_config_dword(child, pos + PCI_EXP_DEVCAP, &reg32);
		if (!(reg32 & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
			dev_printk(KERN_INFO, &child->dev, "disabling ASPM"
				" on pre-1.1 PCIe device.  You can enable it"
				" with 'pcie_aspm=force'\n");
			return -EINVAL;
		}
	}
	return 0;
}


If MS=Microsoft, that explains it, so windows just disables ASPM on pre 1.1 PCIE devices....

It still is a hardware bug that Atheros device advertises ASPM support, but it is broken.

Best regards,
	Maxim Levitsky

> 
> 
> > 
> > >    Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
> > >    Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
> > >    enabled. With ASPM ath5k will eventually stall on heavy traffic with often
> > >    'unsupported jumbo' warnings appearing. Disabling ASPM L0s in ath5k fixes
> > >    these problems.
> > >
> > >    Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
> > >    both ends (usually stalls within seconds).
> > 
> > I *highly* discourage the use of pcie_aspm=force, in fact I'm inclined
> > to just remove this junk code from the kernel. What you should do to
> > test ASPM on a device is to use setpci on the config space. I have
> > documented how you can do this here:
> 
> > 
> > http://wireless.kernel.org/en/users/Documentation/ASPM
> > 
> > Reason for discouraging this is when you use this you enable ASPM on
> > *all* root complexes and *all* devices which do support ASPM. If you
> > have another device which is capable of ASPM but has it disabled for
> > some reason you will run into other issues.
> > 
> > I should also note that loading a module already has an effect on
> > devices for ASPM. An example today is ath9k's ath9k_hw_init() which
> > runs simply during module load, this has some ASPM related code which
> > for example disables the PLL for ASPM for AR9003. I don't recall
> > exactly what we do with ath5k but just giving you an idea. To truly
> > test ASPM well I recommend to do something similar as with this script
> > or you can just give it a shot.
> > 
> > http://kernel.org/pub/linux/kernel/people/mcgrof/aspm/enable-aspm
> > 
> > Not like I expect very different results but just wanted to clarify
> > the details on force aspm.
> > 
> > Why are you disabling L0s for all devices though? Why not just for the
> > reported device? Granted, L0s won't save you much more power but
> > still, why remove it completely, your commit log does not address that
> > in any way. It only states you have issues with L0s on one chipset but
> > what the patch really implies is you are disabling L0s completely for
> > all ath5k chipsets.
> First of all there aren't many PCIE ath5k based devices.
> Two of them are known to be broken.
> Also Jussi Kivilinna said that he found that in windows .inf file there
> are some instructions to enable L1 but not L0s.
> 
> 
> Note that I tested that again, and card works very stable.
> I didn't see a single drop to 0 bytes/s. In fact throughput never drops
> below 1 Mb/s. (usually about 2.4 Mb/s, with rare drops for few seconds
> to ~1Mb/s)
> 
> 
> Best regards,
> Maxim Levitsky
> 
> > 
> > David, are you aware of recent L0s issues with some legacy cards?
> > 
> > >    Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> > >    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > >
> > >
> > > diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> > > index 3abbe75..e7a189a 100644
> > > --- a/drivers/net/wireless/ath/ath5k/base.c
> > > +++ b/drivers/net/wireless/ath/ath5k/base.c
> > > @@ -48,6 +48,7 @@
> > >  #include <linux/netdevice.h>
> > >  #include <linux/cache.h>
> > >  #include <linux/pci.h>
> > > +#include <linux/pci-aspm.h>
> > >  #include <linux/ethtool.h>
> > >  #include <linux/uaccess.h>
> > >  #include <linux/slab.h>
> > > @@ -469,6 +470,9 @@ ath5k_pci_probe(struct pci_dev *pdev,
> > >        int ret;
> > >        u8 csz;
> > >
> > > +       /* Disable PCIE ASPM L0S. It is never enabled by windows driver */
> > > +       pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> > > +
> > >        ret = pci_enable_device(pdev);
> > >        if (ret) {
> > >                dev_err(&pdev->dev, "can't enable device\n");
> > > @@ -722,6 +726,8 @@ static int ath5k_pci_resume(struct device *dev)
> > >        struct ieee80211_hw *hw = pci_get_drvdata(pdev);
> > >        struct ath5k_softc *sc = hw->priv;
> > >
> > > +       pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> > > +
> > >        /*
> > >         * Suspend/Resume resets the PCI configuration space, so we have to
> > >         * re-disable the RETRY_TIMEOUT register (0x41) to keep
> > >
> > >
> > >
> > >
> > >
> > >
> > > _______________________________________________
> > > ath5k-devel mailing list
> > > ath5k-devel@lists.ath5k.org
> > > https://lists.ath5k.org/mailman/listinfo/ath5k-devel
> > >
> 
> 


