Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab0LGVc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:32:59 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42909 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0LGVc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=rT9bw/3gVNCCa0e+oSs6w/2mf5kAQQ9X+v1LH/gvOTSuGASWcyLUz3DCZWyZzDqaWr
         ZaEeBZRVNXfOPEaSTtr08x3nwzYTNSJ7jfOQ7zni8aeIgT3v1a87OWp8mGRzUrPLfgoe
         2w6qXwb47KlVN07fFmlhKGHpsHdIuZ295WIcI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTi=hUfKWWkwD+MuuZx_B7Th+xc_g-W6OSvU-3dP3@mail.gmail.com>
References: <AANLkTik1P7vQbgL8qxoTEEyR0D0cTV+9zsBcHT3L_nwm@mail.gmail.com>
	<20101207142639.GB2700@tuxdriver.com>
	<AANLkTinjx-+Fv-1CKx6pJwx2FcxiH7skEsqDQtETtBUT@mail.gmail.com>
	<20101207155924.GC2700@tuxdriver.com>
	<AANLkTi=hUfKWWkwD+MuuZx_B7Th+xc_g-W6OSvU-3dP3@mail.gmail.com>
Date: Tue, 7 Dec 2010 22:32:57 +0100
Message-ID: <AANLkTikJHbyv-on0z1V=xV_Q=LRjAEkcMeP89N-U=OMO@mail.gmail.com>
Subject: Re: [linux-next] next-20101207: Better now, but modinfo ath5k
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nick Kossifidis <mickflemm@gmail.com>, Bruno Randolf <br1@einfach.org>,
        ath5k-devel <ath5k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 7:13 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Tue, Dec 7, 2010 at 4:59 PM, John W. Linville <linville@tuxdriver.com> wrote:
>> On Tue, Dec 07, 2010 at 04:57:08PM +0100, Sedat Dilek wrote:
>>> On Tue, Dec 7, 2010 at 3:26 PM, John W. Linville <linville@tuxdriver.com> wrote:
>>> > On Tue, Dec 07, 2010 at 12:24:14PM +0100, Sedat Dilek wrote:
>>> >
>>> >> I have already reported on linux-wireless (short: l-w) ML that after
>>> >> especially the merge of "AHB Bus support" patchset (see [2]) my ath5k
>>> >> was not working as expected in daily use (also modinfo).
>>> >>
>>> >> I am not sure if it is the driver but reverting the 9 commits in my
>>> >> local linux-next GIT seemed to "stabilize" a bit the Internet
>>> >> connection.
>>> >> The patchset from Nick (see below) definitely helped to stabilize ath5k.
>>> >
>>> > I imagine that these are the "9 commits" you mean:
>>> >
>>> >> git rev-list c30ae13..4cebb34
>>> > 4cebb34caa5122216a1e2451eae9e0fc47ec2589
>>> > a0b907ee2a71052fefdf6151764095f3f97b3275
>>> > c31b5c9c806b1fbdc9e98885d897664a0d482989
>>> > e7aecd327d80b2f156b54769013aaccb2a20645a
>>> > 8efa5d7d6ad307ae2d220def37ca89594062c40d
>>> > 4aa5d783c9e1c72e4950ff34f388077ccecac74a
>>> > e5b046d86fac609f636d127a38de94a175c7e83b
>>> > 132b1c3ee38ea6fa0501004fd0f19acb554e5a44
>>> > aeae4ac9090462ea38387dcdbac4f01b944af6a4
>>> >
>>> > Most of those look fairly harmless so long as you don't define
>>> > CONFIG_ATHEROS_AR231X.  Just to narrow things down...if you only revert
>>> > the first 8 (i.e. leave aeae4ac alone), do you still have problems?
>>> > Or does it still "stabilize"?
>>> >
>>> > That patch converts the driver to the generic DMA API.  It seems
>>> > OK at first glance, but I suspect it is the only one likely to be
>>> > effecting your situation.
>>> >
>>> > John
>>> > --
>>> > John W. Linville                Someday the world will need a hero, and you
>>> > linville@tuxdriver.com                  might be all we have.  Be ready.
>>> >
>>>
>>> Before jumping to another problem, I had a quick look into the
>>> appropriate Kconfig file, as you say I have not CONFIG_ATHEROS_AR231X
>>> set and that's why AHB support is not selected/built, instead
>>>
>>>   CC [M]  drivers/net/wireless/ath/ath5k/pci.o
>>>
>>> is built.
>>>
>>> Unfortunately, I can't cleanly revert. Sorry, I can't help.
>>
>> I don't quite understand -- you said you were reverting them before,
>> but now I ask you to revert one _less_ patch (i.e. the last one to
>> be reverted anyway) and you can't do it?
>>
>> John
>> --
>> John W. Linville                Someday the world will need a hero, and you
>> linville@tuxdriver.com                  might be all we have.  Be ready.
>>
>
> I tested with a linux-next (next-20101206) with revert-at5k-patches.
> Unfortunately, Nick's patchset is needed for a stable WLAN connection,
> several ReAssoc's etc.
> So, I can't give a comment to the effects of the AHB patchset on my AR5212.
>
> But... I have found the culprit patch which makes modinfo no more list
> the aliases/pci-id (see [1]):
>
> commit e5b046d86fac609f636d127a38de94a175c7e83b
> "ath5k: Move PCI bus functions to separate file."
>
> - Sedat -
>
> [1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=e5b046d86fac609f636d127a38de94a175c7e83b
>
> $ ~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none
>
> $ cat .pc/applied-patches
> revert-ath5k-patches/0001-Revert-ath5k-Fix-reset-and-interrupts-for-AHB-type-o.patch
> revert-ath5k-patches/0002-Revert-ath5k-Add-AHB-bus-support.patch
> revert-ath5k-patches/0003-Revert-ath5k-Add-initial-registers-values-for-radio-.patch
> revert-ath5k-patches/0004-Revert-ath5k-Add-a-function-to-read-chipset-s-MAC-re.patch
> revert-ath5k-patches/0005-Revert-ath5k-Check-if-pci-pdev-struct-is-initialized.patch
> revert-ath5k-patches/0006-Revert-ath5k-Use-generic-eeprom-read-from-common-ath.patch
> revert-ath5k-patches/0007-Revert-ath5k-Move-PCI-bus-functions-to-separate-file.patch
>
> # modinfo ath5k
> filename:
> /lib/modules/2.6.37-rc4-686/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
> version:        0.6.0 (EXPERIMENTAL)
> license:        Dual BSD/GPL
> description:    Support for 5xxx series of Atheros 802.11 wireless LAN
> cards.
> author:         Nick Kossifidis
> author:         Jiri Slaby
> srcversion:     666105BAEE881F2C2F10CE6
> alias:          pci:v0000168Cd0000001Dsv*sd*bc*sc*i*
> alias:          pci:v0000168Cd0000001Csv*sd*bc*sc*i*
> alias:          pci:v0000168Cd0000001Bsv*sd*bc*sc*i*
> alias:          pci:v0000168Cd0000001Asv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000019sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000018sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000017sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000016sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000015sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000014sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00001014sv*sd*bc*sc*i*
> alias:          pci:v000010B7d00000013sv*sd*bc*sc*i*
> alias:          pci:v0000A727d00000013sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000013sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000012sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000011sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000007sv*sd*bc*sc*i*
> alias:          pci:v0000168Cd00000207sv*sd*bc*sc*i*
> depends:        mac80211,cfg80211,ath
> vermagic:       2.6.37-rc4-686 SMP mod_unload modversions 686
> parm:           debug:uint
> parm:           nohwcrypt:Disable hardware encryption. (bool)
> parm:           all_channels:Expose all channels the device can use. (bool)
>

I have found the cause for the modinfo problem, here is a fix (I will
send later a separate patch):

$ diff -Naur drivers/net/wireless/ath/ath5k/pci.c.orig
drivers/net/wireless/ath/ath5k/pci.c
--- drivers/net/wireless/ath/ath5k/pci.c.orig   2010-12-07
19:34:53.999334165 +0100
+++ drivers/net/wireless/ath/ath5k/pci.c        2010-12-07
22:25:20.387028188 +0100
@@ -45,6 +45,7 @@
        { PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
        { 0 }
 };
+MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);

 /* return bus cachesize in 4B word units */
 static void ath5k_pci_read_cachesize(struct ath_common *common, int *csz)

# modinfo ath5k
filename:
/lib/modules/2.6.37-rc4-686/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
version:        0.6.0 (EXPERIMENTAL)
license:        Dual BSD/GPL
description:    Support for 5xxx series of Atheros 802.11 wireless LAN
cards.
author:         Nick Kossifidis
author:         Jiri Slaby
srcversion:     1B224A604952CD0597CA568
alias:          pci:v0000168Cd0000001Dsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000001Csv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000001Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000001Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000019sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000018sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000017sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000016sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000015sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000014sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00001014sv*sd*bc*sc*i*
alias:          pci:v000010B7d00000013sv*sd*bc*sc*i*
alias:          pci:v0000A727d00000013sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000013sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000012sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000011sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000007sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000207sv*sd*bc*sc*i*
depends:        mac80211,cfg80211,ath
vermagic:       2.6.37-rc4-686 SMP mod_unload modversions 686
parm:           debug:uint
parm:           nohwcrypt:Disable hardware encryption. (bool)
parm:           all_channels:Expose all channels the device can use. (bool)
