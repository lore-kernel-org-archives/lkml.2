Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab2EDP61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:58:27 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:45111 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751140Ab2EDP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:58:25 -0400
Message-ID: <4FA3FC9B.9050600@fold.natur.cuni.cz>
Date: Fri, 04 May 2012 17:58:19 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <4F6A5A53.305@fold.natur.cuni.cz> <CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com> <4F8BEB1D.9080903@fold.natur.cuni.cz> <CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com> <4F8C6E4E.1000205@fold.natur.cuni.cz> <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com> <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com> <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com> <4F8D1B72.2000105@fold.natur.cuni.cz> <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com> <4F8D390F.9050408@fold.natur.cuni.cz> <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com> <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com> <4F8EFFA3.3050705@fold.natur.cuni.cz> <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com>
In-Reply-To: <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Apr 18, 2012 at 10:53 AM, Martin Mokrejs
> <mmokrejs@fold.natur.cuni.cz> wrote:
>>> After you remove USB3 expresscard, you need to
>>>
>>> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>> then
>>> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>
>> So without these two echo commands the is no improvement/fix.
>>
>> [  686.701306] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
>> [  686.701316] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>> [  686.701319] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
>> [  686.701357] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>> [  686.701390] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
>> [  686.809763] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> ...
>> [  686.833678] hub 6-0:1.0: 2 ports detected
>>
>> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>
>> [  716.999938] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 53
>> [  717.024647] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
>> [  717.024657] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>> [  717.024665] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
>> [  717.024723] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>> [  717.024753] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
>> [  717.024756] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> ..
>> [  717.045197] pci 0000:11:00.0: freeing pci_dev info
>>
>> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>
>> [  748.456914] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 40
>>
> 
> so it is chipset problem, it does not detect and report the presence
> of the card after that link is removed.
> 
> Can you try to use acpiphp instead of pciehp?


When I am booted up with CONFIG_HOTPLUG_PCI_ACPI=n and pcie_aspm=off I tested what
happens with several cards. Note that this scenario causes "Unable to request _OSC
control" below and functionally disables my ExpressCard slot:

- Command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0 log_buf_len=409600
+ Command line: root=/dev/sda5 pciehp.pciehp_debug=1 console=ttyUSB0,115200n8 console=tty0 log_buf_len=409600 pcie_aspm=off

-pci0000:00: Requesting ACPI _OSC control (0x1d)   
-pci0000:00: ACPI _OSC control (0x19) granted   
+pci0000:00: Unable to request _OSC control (_OSC support mask:

The express card works although no driver can pickup and therefore nothing was ever logged
through syslog if I plugged in the card,. Still, I could read the lspci output and compare values.


# dmesg > dmesg_without_CONFIG_HOTPLUG_PCI_ACPI_with_pcie_aspm_off.txt 
# lspci -vvxxx -s 00:1c.7 > 1_fresh_bootup.txt
# echo 7 > /proc/sys/kernel/printk

# # inserted DeLock card
# lspci -vvxxx -s 00:1c.7 > 1_inserted_DeLock_unrecognized.txt
# # card removed
# lspci -vvxxx -s 00:1c.7 > 2_unplugged_DeLock_unrecognized.txt
# # re-inserted the card
# lspci -vvxxx -s 00:1c.7 > 3_re-inserted_DeLock_again_unrecognized.txt
# # unplugged and re-inserted the card
# lspci -vvxxx -s 00:1c.7 > 4_unplug_and_re-plug_DeLock_again_unrecognized.txt
# # unplugged DeLock card
# lspci -vvxxx -s 00:1c.7 > 5_unplugged_DeLock_unrecognized.txt

# ## will now play with Evolve_SpeedCard_HC-303SCX with NEC uPD720200 rev. 3
# # inserting Evolve_SpeedCard_HC-303SCX with NEC uPD720200 rev. 3
# lspci -vvxxx -s 00:1c.7 > 6_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt
# # popped out, grabbing lspci to proof that later
# lspci -vvxxx -s 00:1c.7 > 7_popped_out_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt
# # re-inserting, sits in now for sure
# lspci -vvxxx -s 00:1c.7 > 8_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt
# # removed
# lspci -vvxxx -s 00:1c.7 > 9_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt
# # re-inserting, 2 attempts to get card held mechanically
# lspci -vvxxx -s 00:1c.7 > 9_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt
# # unplugging card, nothing appeared in syslog
# lspci -vvxxx -s 00:1c.7 > 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt

# ## now will play with Zalman ZM-EC302 U3 card having also NEC uPD720200 rev. 3
# # inserting
# lspci -vvxxx -s 00:1c.7 > 11_inserted_Zalman_ZM-EC302_U3.txt
# # removed the card
# lspci -vvxxx -s 00:1c.7 > 12_unplugged_Zalman_ZM-EC302_U3.txt
# # re-inserting
# lspci -vvxxx -s 00:1c.7 > 13_re-inserted_Zalman_ZM-EC302_U3.txt
# # removing
# lspci -vvxxx -s 00:1c.7 > 14_unplugged_Zalman_ZM-EC302_U3.txt

# # inserting Axago-ECF-X1_FireWireCard    
# lspci -vvxxx -s 00:1c.7 > 15_inserted_Axago-ECF-X1_FireWireCard.txt
# # removed Axago-ECF-X1_FireWireCard
# lspci -vvxxx -s 00:1c.7 > 16_unplugged_Axago-ECF-X1_FireWireCard.txt
# # re-inserted
# lspci -vvxxx -s 00:1c.7 > 17_re-inserted_Axago-ECF-X1_FireWireCard.txt
# # unplugged
# lspci -vvxxx -s 00:1c.7 > 18_unplugged_Axago-ECF-X1_FireWireCard.txt
#


# diff -u -w 1_fresh_bootup.txt 1_inserted_DeLock_unrecognized.txt
--- 1_fresh_bootup.txt  2012-05-04 15:25:23.000000000 +0200
+++ 1_inserted_DeLock_unrecognized.txt  2012-05-04 15:27:29.000000000 +0200
@@ -16,17 +16,17 @@
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
-               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
+               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
+               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
-                       Changed: MRL- PresDet- LinkState-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+                       Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
@@ -48,8 +48,8 @@
 10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 08
-50: 02 00 01 10 60 b2 3c 00 00 00 00 00 00 00 00 00
+40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
+50: 40 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00

#


The "PresDet-" on Changed: line does not change but the one on SltSta: line does!
Is that because of the fresh bootup and no previous value to compare with?
No, it never changes even on all below diff outputs. But could Linux cache
the value itself to correct for that?



# diff -u -w 1_inserted_DeLock_unrecognized.txt 2_unplugged_DeLock_unrecognized.txt 
--- 1_inserted_DeLock_unrecognized.txt  2012-05-04 15:27:29.000000000 +0200
+++ 2_unplugged_DeLock_unrecognized.txt 2012-05-04 15:34:12.000000000 +0200
@@ -20,12 +20,12 @@
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
-50: 40 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
+50: 40 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00

# diff -u -w 3_re-inserted_DeLock_again_unrecognized.txt 4_unplug_and_re-plug_DeLock_again_unrecognized.txt 
--- 3_re-inserted_DeLock_again_unrecognized.txt 2012-05-04 15:38:55.000000000 +0200
+++ 4_unplug_and_re-plug_DeLock_again_unrecognized.txt  2012-05-04 15:40:05.000000000 +0200
@@ -20,12 +20,12 @@
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
-50: 40 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
+50: 40 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00


# diff -u -w 4_unplug_and_re-plug_DeLock_again_unrecognized.txt 5_unplugged_DeLock_unrecognized.txt 
--- 4_unplug_and_re-plug_DeLock_again_unrecognized.txt  2012-05-04 15:40:05.000000000 +0200
+++ 5_unplugged_DeLock_unrecognized.txt 2012-05-04 15:40:48.000000000 +0200
@@ -20,12 +20,12 @@
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
-50: 40 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
+50: 40 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00



In the below difference, why is there the MAbort+? Is that because
I did not manage to fit in the card so that in was actually unplugged
(no diff between 6_inserted_Ev*.txt and 7_popped_out_Evolve*.txt files
explained below)?

# diff -u -w 5_unplugged_DeLock_unrecognized.txt 6_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 
--- 5_unplugged_DeLock_unrecognized.txt 2012-05-04 15:40:48.000000000 +0200
+++ 6_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt   2012-05-04 15:43:16.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -15,10 +15,10 @@
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
-               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
+               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
@@ -45,11 +45,11 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 00 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
-50: 40 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
+40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
+50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 
# diff -u -w 6_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 7_popped_out_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 

OK, so the card was really out in bot cases. But then it means that
the "diff -u -w 5_unplugged_DeLock_unrecognized.txt 6_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt"
shows the changed to an empty expresscard slot state when Delock was out and after NEC was out). That is why the
PresDet does not appear on a changed line. So, what are those other differences?



Further continuing the comparison, so below I compared the empty slot state (7_popped_out*.txt) with successfull insertion
of the NEC card. Indeed, it has the PresDet changed correctly from "-" to "+".

# diff -u -w 7_popped_out_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 8_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 
--- 7_popped_out_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 2012-05-04 15:44:08.000000000 +0200
+++ 8_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt   2012-05-04 15:44:58.000000000 +0200
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
+50: 43 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00


# diff -u -w 8_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 9_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 
--- 8_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt   2012-05-04 15:44:58.000000000 +0200
+++ 9_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt  2012-05-04 15:45:46.000000000 +0200
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 43 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
+50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00


# diff -u -w 9_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 9_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 
--- 9_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt  2012-05-04 15:45:46.000000000 +0200
+++ 9_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt   2012-05-04 15:46:44.000000000 +0200
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
+50: 43 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00


# diff -u -w 9_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 
--- 9_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt   2012-05-04 15:46:44.000000000 +0200
+++ 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 2012-05-04 15:47:34.000000000 +0200
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 43 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
+50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00


# diff -u -w 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 11_inserted_Zalman_ZM-EC302_U3.txt 
--- 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 2012-05-04 15:47:34.000000000 +0200
+++ 11_inserted_Zalman_ZM-EC302_U3.txt  2012-05-04 15:48:43.000000000 +0200
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
+50: 43 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00


# diff -u -w 11_inserted_Zalman_ZM-EC302_U3.txt 12_unplugged_Zalman_ZM-EC302_U3.txt 
--- 11_inserted_Zalman_ZM-EC302_U3.txt  2012-05-04 15:48:43.000000000 +0200
+++ 12_unplugged_Zalman_ZM-EC302_U3.txt 2012-05-04 15:49:48.000000000 +0200
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 43 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
+50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00


# diff -u -w 12_unplugged_Zalman_ZM-EC302_U3.txt 13_re-inserted_Zalman_ZM-EC302_U3.txt 
--- 12_unplugged_Zalman_ZM-EC302_U3.txt 2012-05-04 15:49:48.000000000 +0200
+++ 13_re-inserted_Zalman_ZM-EC302_U3.txt       2012-05-04 15:50:18.000000000 +0200
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
+50: 43 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00


# diff -u -w 13_re-inserted_Zalman_ZM-EC302_U3.txt 14_unplugged_Zalman_ZM-EC302_U3.txt
--- 13_re-inserted_Zalman_ZM-EC302_U3.txt       2012-05-04 15:50:18.000000000 +0200
+++ 14_unplugged_Zalman_ZM-EC302_U3.txt         2012-05-04 15:52:31.000000000 +0200
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 43 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
+50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00



Now, let's check whether the chip was in same state when card was out:

# diff -u -w 1_fresh_bootup.txt 2_unplugged_DeLock_unrecognized.txt
--- 1_fresh_bootup.txt  2012-05-04 15:25:23.000000000 +0200
+++ 2_unplugged_DeLock_unrecognized.txt 2012-05-04 15:34:12.000000000 +0200
@@ -16,17 +16,17 @@
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
-               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
+               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
+               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
-                       Changed: MRL- PresDet- LinkState-
+                       Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
@@ -48,8 +48,8 @@
 10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 08
-50: 02 00 01 10 60 b2 3c 00 00 00 00 00 00 00 00 00
+40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
+50: 40 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00



# diff -u -w 2_unplugged_DeLock_unrecognized.txt 3_re-inserted_DeLock_again_unrecognized.txt
#

Yeah, it really slipped out at that moment.

# diff -u -w 3_re-inserted_DeLock_again_unrecognized.txt 5_unplugged_DeLock_unrecognized.txt
#

Good, no diff.


# diff -u -w 7_popped_out_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 9_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt
#

Good, empty slot is always in same state.

# diff -u -w 9_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt

Also when I swap the vendor of the USB3.0 card.

# diff -u -w 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 12_unplugged_Zalman_ZM-EC302_U3.txt
# diff -u -w 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt  14_unplugged_Zalman_ZM-EC302_U3.txt
#

So, empty slot ends up in a different state when I remove DeLock 61386 providin 2x eSATA ports.
It has 2 LEDs to signal data transfer. Both NEC-based cards have optional 5V/2A power input.
Only the one from Zalman has a power-on light (or in-slot?).



I followed up now with a FireWire Card which unplug was always detected. If I compare state of empty
card slot I get again a difference betwee the state left out after NEC-based card and this FireWire card.


# diff -u -w 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt  16_unplugged_Axago-ECF-X1_FireWireCard.txt 
--- 10_unplugged_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 2012-05-04 15:47:34.000000000 +0200
+++ 16_unplugged_Axago-ECF-X1_FireWireCard.txt  2012-05-04 17:08:47.000000000 +0200
@@ -18,7 +18,7 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 42 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
+50: 40 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00

# diff -u -w 16_unplugged_Axago-ECF-X1_FireWireCard.txt 18_unplugged_Axago-ECF-X1_FireWireCard.txt 
#

# diff -u -w 1_fresh_bootup.txt 16_unplugged_Axago-ECF-X1_FireWireCard.txt
--- 1_fresh_bootup.txt  2012-05-04 15:25:23.000000000 +0200
+++ 16_unplugged_Axago-ECF-X1_FireWireCard.txt  2012-05-04 17:08:47.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -15,18 +15,18 @@
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
-               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
-               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
+               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
+               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
+               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
-                       Changed: MRL- PresDet- LinkState-
+                       Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
@@ -45,11 +45,11 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 00 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 08
-50: 02 00 01 10 60 b2 3c 00 00 00 00 00 00 00 00 00
+40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
+50: 40 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 
Hmm, is the above difference caused by the fact the errors were left in because meanwhile I was using the NEC-based cards?

# diff -u -w 2_unplugged_DeLock_unrecognized.txt 16_unplugged_Axago-ECF-X1_FireWireCard.txt
--- 2_unplugged_DeLock_unrecognized.txt 2012-05-04 15:34:12.000000000 +0200
+++ 16_unplugged_Axago-ECF-X1_FireWireCard.txt  2012-05-04 17:08:47.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -15,7 +15,7 @@
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
-               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
+               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
@@ -45,10 +45,10 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 00 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
+40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
 50: 40 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00

Seems so, even comparing with the state after DeLock removal there is still some difference left.



When I go and comapre states when a card was inserted I see only two differences, likely caused
by using the NEC-based cards some while ago.

# diff -u -w 1_inserted_DeLock_unrecognized.txt 15_inserted_Axago-ECF-X1_FireWireCard.txt 
--- 1_inserted_DeLock_unrecognized.txt  2012-05-04 15:27:29.000000000 +0200
+++ 15_inserted_Axago-ECF-X1_FireWireCard.txt   2012-05-04 17:08:15.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -15,7 +15,7 @@
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
-               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
+               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
@@ -45,10 +45,10 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 00 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
+40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
 50: 40 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 

So, does the card detection work? Yes, it does, like always. :-)

# diff -u -w 15_inserted_Axago-ECF-X1_FireWireCard.txt 16_unplugged_Axago-ECF-X1_FireWireCard.txt 
--- 15_inserted_Axago-ECF-X1_FireWireCard.txt   2012-05-04 17:08:15.000000000 +0200
+++ 16_unplugged_Axago-ECF-X1_FireWireCard.txt  2012-05-04 17:08:47.000000000 +0200
@@ -20,12 +20,12 @@
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 40 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
+50: 40 00 11 50 60 b2 3c 00 00 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00

#



Next, with the below comparison I think I just document that in the some time between
using the DeLock card and the FireWire card there were MAbort+ and CorrErr+ set (caused
by the NEC).


# diff -u -w 1_inserted_DeLock_unrecognized.txt 15_inserted_Axago-ECF-X1_FireWireCard.txt 
--- 1_inserted_DeLock_unrecognized.txt  2012-05-04 15:27:29.000000000 +0200
+++ 15_inserted_Axago-ECF-X1_FireWireCard.txt   2012-05-04 17:08:15.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -15,7 +15,7 @@
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
-               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
+               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
@@ -45,10 +45,10 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 00 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 08
+40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
 50: 40 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 


Finally, comparing states when NEC-based and FireWire card were in the slot. I think this is
interesting.

# diff -u -w 8_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 15_inserted_Axago-ECF-X1_FireWireCard.txt 
--- 8_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt   2012-05-04 15:44:58.000000000 +0200
+++ 15_inserted_Axago-ECF-X1_FireWireCard.txt   2012-05-04 17:08:15.000000000 +0200
@@ -18,7 +18,7 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 43 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
+50: 40 00 11 70 60 b2 3c 00 00 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00

#

I would get same difference against teh other NEC-based card but so save output I rather show
that when the card is in a slot it is in same state.

# diff -u -w 8_inserted_Evolve_SpeedCard_HC-303SCX_with_NEC_uPD720200_rev3.txt 11_inserted_Zalman_ZM-EC302_U3.txt 
#


First, if hardware does not report Changed PresDet+ and always says "PresDet-" linux could
keep do the comparisons on its own. Second, why does the NEC-chip "ignore?" the pcie_aspm=off
and mangles with the LnkCtl: ASPM? Unlike DeLock eSATA and Axago FireWire cards?
Or, does it make sense at all? ;-)

All of this was with plain 3.4-rc5.
Thanks,
Martin
