Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037Ab1CEDp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 22:45:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41940 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1CEDpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 22:45:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oIJIJvHDr0tF1hLPOAnl5HRmPIyJMTE1O5FyHIkmY3lYr6xJOKDh5fN0UIr/NPGgwc
         009/2X6vKlNLodkqHibRAf/nKRkX9CjzgeOBSP3jwm2japInCwvssZeuvmgBhvkFc15Q
         lldVpJ6OTD2vgTRH42NtGx75ybQI8HovF8eMQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	<20110304134648.GB9866@tuxdriver.com>
	<1299251879.24333.3.camel@wwguy-ubuntu>
	<AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
Date: Sat, 5 Mar 2011 03:45:22 +0000
Message-ID: <AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
Subject: Re: 2.6.38-rc7, iwlagn crash
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2011 22:23, Mathias Burén <mathias.buren@gmail.com> wrote:
> On 4 March 2011 15:17, wwguy <wey-yi.w.guy@intel.com> wrote:
>> On Fri, 2011-03-04 at 05:46 -0800, John W. Linville wrote:
>>> Cc'ing Wey-yi and linux-wireless...anyone else having problems with
>>> iwlagn and IBSS?
>>>
>>> On Fri, Mar 04, 2011 at 03:27:22AM +0000, Mathias Burén wrote:
>>> > Hi,
>>> >
>>> > (please cc as not subscribed)
>>> >
>>> >
>>> >
>>> > I think the crash happens when the phone attempts to get an IP, at
>>> > least that's what the phone says right after/at the crash. Any ideas?
>>> >
>>> >
>> forwarding to my team to work on it, any additional information you can
>> provide?
>>
>> It is in IBSS mode, do you have any information can shared with us on
>> your phone's model, setup, and ...
>> if you can load the module with debug=0x43fff and provide the dmesg log,
>> it will be very helpful
>>
>> Thanks
>> Wey
>>
>>
>>
>
> Hi,
>
> The phone is a Samsung Galaxy S (with "modded" wpa_supplicant to see
> adhoc networks). I created a new adhoc network in Ubuntu using the
> NetworkManager applet, with SSID "UbuntuAdhoc", band "automatic",
> BSSID (blank) and no security. Under IPV4 settings I set it to "Shared
> to other computers". Unfortunately I get this when trying to load the
> module with debug:
>
> $ sudo modprobe -v iwlagn debug=0x43fff
> insmod /lib/modules/2.6.38-020638rc7-generic/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko
> 11n_disable=1 debug=0x43fff
> FATAL: Error inserting iwlagn
> (/lib/modules/2.6.38-020638rc7-generic/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> [  447.551540] iwlagn: Unknown parameter `debug'
>
> $ sudo modprobe -v iwlagn
> insmod /lib/modules/2.6.38-020638rc7-generic/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko
> 11n_disable=1
>
>
> [  501.570685] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
> Linux, in-tree:
> [  501.570688] iwlagn: Copyright(c) 2003-2010 Intel Corporation
> [  501.570760] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [  501.570772] iwlagn 0000:03:00.0: setting latency timer to 64
> [  501.570809] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R)
> Advanced-N 6200 AGN, REV=0x74
> [  501.580698] iwlagn 0000:03:00.0: device EEPROM VER=0x436, CALIB=0x6
> [  501.580703] iwlagn 0000:03:00.0: Device SKU: 0Xb
> [  501.580739] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24
> 802.11a channels
> [  501.580836] iwlagn 0000:03:00.0: irq 44 for MSI/MSI-X
> [  501.583936] iwlagn 0000:03:00.0: loaded firmware version 9.221.4.1
> build 25532
> [  501.584236] cfg80211: Ignoring regulatory request Set by core since
> the driver uses its own custom regulatory domain
> [  501.584392] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
>
> Here I create the adhoc network in network manager:
>
> [  536.509700] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  536.858139] cfg80211: Found new beacon on frequency: 2472 MHz (Ch 13) on phy0
> [  536.947735] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy0
> [  537.041220] cfg80211: Found new beacon on frequency: 5200 MHz (Ch 40) on phy0
> [  537.079114] cfg80211: Found new beacon on frequency: 5220 MHz (Ch 44) on phy0
> [  537.175392] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy0
> [  538.973811] cfg80211: Found new beacon on frequency: 5745 MHz (Ch
> 149) on phy0
> [  539.203969] cfg80211: Found new beacon on frequency: 5785 MHz (Ch
> 157) on phy0
> [  539.289182] cfg80211: Found new beacon on frequency: 5805 MHz (Ch
> 161) on phy0
> [  571.156548] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  599.156798] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  599.161234] wlan0: Trigger new scan to find an IBSS to join
> [  604.131831] wlan0: Trigger new scan to find an IBSS to join
> [  607.103522] wlan0: Creating new IBSS network, BSSID 42:dd:e6:af:fb:19
> [  607.104488] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> [  607.105407] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> [  608.501173] wlan0: Trigger new scan to find an IBSS to join
> [  609.190883] wlan0: no IPv6 routers present
> [  613.397068] wlan0: Trigger new scan to find an IBSS to join
> [  616.303044] wlan0: Creating new IBSS network, BSSID ae:eb:cb:59:18:ec
> [  616.313716] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> [  616.314529] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> [  617.681034] wlan0: Trigger new scan to find an IBSS to join
> [  622.736806] wlan0: Trigger new scan to find an IBSS to join
> [  625.708399] wlan0: Creating new IBSS network, BSSID 46:b6:a0:1b:c4:7f
> [  625.761157] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> [  625.762035] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> [  627.438640] iwlagn 0000:03:00.0: Error sending REPLY_RXON_TIMING:
> time out after 500ms.
> [  627.438648] iwlagn 0000:03:00.0: Failed to send timing (-110)!
> [  627.438651] ------------[ cut here ]------------
> [  627.438668] WARNING: at
> /home/kernel-ppa/COD/linux/drivers/net/wireless/iwlwifi/iwl-core.c:1898
> iwl_mac_change_interface+0x12e/0x130 [iwlcore]()
> [  627.438672] Hardware name: 4384BB3
> [  627.438674] Modules linked in: nf_nat_h323 nf_conntrack_h323
> nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gre
> nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc
> nf_nat_ftp iwlagn iwlcore mac80211 cfg80211 xt_limit xt_tcpudp ipt_LOG
> ipt_MASQUERADE xt_DSCP ipt_REJECT nf_conntrack_irc nf_conntrack_ftp
> xt_state binfmt_misc vboxnetadp vboxnetflt vboxdrv microcode
> parport_pc ppdev iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
> nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables
> snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec
> snd_hwdep snd_pcm snd_seq_midi joydev snd_rawmidi hdaps thinkpad_ec
> snd_seq_midi_event arc4 snd_seq snd_timer uvcvideo videodev
> snd_seq_device psmouse v4l2_compat_ioctl32 thinkpad_acpi tpm_tis tpm
> tpm_bios nvram lp serio_raw parport snd soundcore intel_ips
> snd_page_alloc sha256_generic aesni_intel cryptd aes_x86_64
> aes_generic dm_crypt usbhid hid i915 firewire_ohci ahci drm_kms_helper
> e1000e libahci drm sdhci_pci firewire_core sdhci crc_itu_t
> i2c_algo_bit video [last unloaded: cfg80211]
> [  627.438764] Pid: 1203, comm: NetworkManager Not tainted
> 2.6.38-020638rc7-generic #201103020909
> [  627.438767] Call Trace:
> [  627.438778]  [<ffffffffa0294c7e>] ?
> iwl_mac_change_interface+0x12e/0x130 [iwlcore]
> [  627.438787]  [<ffffffffa0294c7e>] ?
> iwl_mac_change_interface+0x12e/0x130 [iwlcore]
> [  627.438796]  [<ffffffff81065430>] ? warn_slowpath_common+0x90/0xc0
> [  627.438801]  [<ffffffff8106547a>] ? warn_slowpath_null+0x1a/0x20
> [  627.438809]  [<ffffffffa0294c7e>] ?
> iwl_mac_change_interface+0x12e/0x130 [iwlcore]
> [  627.438827]  [<ffffffffa02589ec>] ?
> ieee80211_runtime_change_iftype+0xdc/0x180 [mac80211]
> [  627.438840]  [<ffffffffa0258b85>] ?
> ieee80211_if_change_type+0xf5/0x120 [mac80211]
> [  627.438854]  [<ffffffffa025b95b>] ?
> ieee80211_change_iface+0x3b/0x130 [mac80211]
> [  627.438865]  [<ffffffffa020a898>] ?
> cfg80211_change_iface+0xe8/0x1c0 [cfg80211]
> [  627.438877]  [<ffffffffa02228f6>] ? cfg80211_wext_siwmode+0xa6/0xf0
> [cfg80211]
> [  627.438884]  [<ffffffff8158a4cb>] ? ioctl_standard_call+0x6b/0xf0
> [  627.438889]  [<ffffffff8158a460>] ? ioctl_standard_call+0x0/0xf0
> [  627.438893]  [<ffffffff81589882>] ? wireless_process_ioctl+0x102/0x130
> [  627.438898]  [<ffffffff8158afe0>] ? ioctl_private_call+0x0/0xa0
> [  627.438902]  [<ffffffff8158afe0>] ? ioctl_private_call+0x0/0xa0
> [  627.438907]  [<ffffffff8158a460>] ? ioctl_standard_call+0x0/0xf0
> [  627.438911]  [<ffffffff8158991c>] ? wext_ioctl_dispatch+0x6c/0x90
> [  627.438916]  [<ffffffff81589b66>] ? wext_handle_ioctl+0x46/0x90
> [  627.438922]  [<ffffffff814c687b>] ? dev_ioctl+0x28b/0x2a0
> [  627.438927]  [<ffffffff814ad25f>] ? sock_ioctl+0xbf/0x280
> [  627.438933]  [<ffffffff811704bd>] ? vfs_ioctl+0x1d/0x50
> [  627.438937]  [<ffffffff81170f79>] ? do_vfs_ioctl+0x69/0x1d0
> [  627.438940]  [<ffffffff81171174>] ? sys_ioctl+0x94/0xa0
> [  627.438945]  [<ffffffff8100c002>] ? system_call_fastpath+0x16/0x1b
> [  627.438949] ---[ end trace c7a5b9f525294bcc ]---
> [  627.552179] wlan0: Trigger new scan to find an IBSS to join
>
> Hm, not much I can do without recompiling the module with debug
> support? Is there a way I can do this without recompiling the kernel?
>
> Kind regards,
> // Mathias
>

I've tried to recompile just the kernel module, but I get various
errors when I try to do so;


root@host:/usr/src/linux-headers-2.6.38-020638rc7# make mrproper && cp
/boot/config-2.6.38-020638rc7-generic .config && yes "" | make
oldconfig && make prepare && make scripts && make menuconfig
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   include/config include/generated
  CLEAN   .config .config.old include/linux/version.h
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --oldconfig Kconfig
#
# configuration written to .config
#
scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
make[1]: *** No rule to make target `kernel/bounds.c', needed by
`kernel/bounds.s'.  Stop.
make: *** [prepare0] Error 2

I suppose I need the kernel source, but it's nowhere to be found here
( http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.38-rc7-natty )
so I'm not sure what to do next.

// Mathias
