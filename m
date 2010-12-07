Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0LGP5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:57:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44266 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0LGP5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:57:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=jOhTxcVvqdKW8z9XHqmGjECuF/TRgO+jnSyjpTlXsIdnClzjNqClqE4czlAsvZoY8M
         9CCx7vNq5u1wKLr32trvCjRS9WIEsJTKVW8S2THqPQUt7UnN8uvUCB9nSkULMIOnwd96
         EvEth4D+Bj81BWzhbzYJ1gsBE4X/c0zm1dLK0=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101207142639.GB2700@tuxdriver.com>
References: <AANLkTik1P7vQbgL8qxoTEEyR0D0cTV+9zsBcHT3L_nwm@mail.gmail.com>
	<20101207142639.GB2700@tuxdriver.com>
Date: Tue, 7 Dec 2010 16:57:08 +0100
Message-ID: <AANLkTinjx-+Fv-1CKx6pJwx2FcxiH7skEsqDQtETtBUT@mail.gmail.com>
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

On Tue, Dec 7, 2010 at 3:26 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Dec 07, 2010 at 12:24:14PM +0100, Sedat Dilek wrote:
>
>> I have already reported on linux-wireless (short: l-w) ML that after
>> especially the merge of "AHB Bus support" patchset (see [2]) my ath5k
>> was not working as expected in daily use (also modinfo).
>>
>> I am not sure if it is the driver but reverting the 9 commits in my
>> local linux-next GIT seemed to "stabilize" a bit the Internet
>> connection.
>> The patchset from Nick (see below) definitely helped to stabilize ath5k.
>
> I imagine that these are the "9 commits" you mean:
>
>> git rev-list c30ae13..4cebb34
> 4cebb34caa5122216a1e2451eae9e0fc47ec2589
> a0b907ee2a71052fefdf6151764095f3f97b3275
> c31b5c9c806b1fbdc9e98885d897664a0d482989
> e7aecd327d80b2f156b54769013aaccb2a20645a
> 8efa5d7d6ad307ae2d220def37ca89594062c40d
> 4aa5d783c9e1c72e4950ff34f388077ccecac74a
> e5b046d86fac609f636d127a38de94a175c7e83b
> 132b1c3ee38ea6fa0501004fd0f19acb554e5a44
> aeae4ac9090462ea38387dcdbac4f01b944af6a4
>
> Most of those look fairly harmless so long as you don't define
> CONFIG_ATHEROS_AR231X.  Just to narrow things down...if you only revert
> the first 8 (i.e. leave aeae4ac alone), do you still have problems?
> Or does it still "stabilize"?
>
> That patch converts the driver to the generic DMA API.  It seems
> OK at first glance, but I suspect it is the only one likely to be
> effecting your situation.
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>

Before jumping to another problem, I had a quick look into the
appropriate Kconfig file, as you say I have not CONFIG_ATHEROS_AR231X
set and that's why AHB support is not selected/built, instead

  CC [M]  drivers/net/wireless/ath/ath5k/pci.o

is built.

Unfortunately, I can't cleanly revert. Sorry, I can't help.

- Sedat -

sd@tbox:~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch 0001-Revert-Add-ath5k-Use-capabilities-information-for-th.patch
patching file drivers/net/wireless/ath/ath5k/base.c
patching file drivers/net/wireless/ath/ath5k/qcu.c

Now at patch 0001-Revert-Add-ath5k-Use-capabilities-information-for-th.patch
sd@tbox:~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch revert-ath5k-patches/0001-Revert-ath5k-Fix-reset-and-interrupts-for-AHB-type-o.patch
patching file drivers/net/wireless/ath/ath5k/base.c
patching file drivers/net/wireless/ath/ath5k/reset.c

Now at patch revert-ath5k-patches/0001-Revert-ath5k-Fix-reset-and-interrupts-for-AHB-type-o.patch
sd@tbox:~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch revert-ath5k-patches/0002-Revert-ath5k-Add-AHB-bus-support.patch
patching file drivers/net/wireless/ath/ath5k/Kconfig
patching file drivers/net/wireless/ath/ath5k/Makefile
patching file drivers/net/wireless/ath/ath5k/ahb.c
patching file drivers/net/wireless/ath/ath5k/ath5k.h
patching file drivers/net/wireless/ath/ath5k/base.c
patching file drivers/net/wireless/ath/ath5k/led.c
patching file drivers/net/wireless/ath/ath5k/reg.h

Now at patch revert-ath5k-patches/0002-Revert-ath5k-Add-AHB-bus-support.patch
sd@tbox:~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch revert-ath5k-patches/0003-Revert-ath5k-Add-initial-registers-values-for-radio-.patch
patching file drivers/net/wireless/ath/ath5k/initvals.c

Now at patch revert-ath5k-patches/0003-Revert-ath5k-Add-initial-registers-values-for-radio-.patch
sd@tbox:~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch revert-ath5k-patches/0004-Revert-ath5k-Add-a-function-to-read-chipset-s-MAC-re.patch
patching file drivers/net/wireless/ath/ath5k/ath5k.h
patching file drivers/net/wireless/ath/ath5k/attach.c
patching file drivers/net/wireless/ath/ath5k/pci.c

Now at patch revert-ath5k-patches/0004-Revert-ath5k-Add-a-function-to-read-chipset-s-MAC-re.patch
sd@tbox:~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch revert-ath5k-patches/0005-Revert-ath5k-Check-if-pci-pdev-struct-is-initialized.patch
patching file drivers/net/wireless/ath/ath5k/attach.c
patching file drivers/net/wireless/ath/ath5k/led.c
patching file drivers/net/wireless/ath/ath5k/reset.c
patching file drivers/net/wireless/ath/ath5k/sysfs.c

Now at patch revert-ath5k-patches/0005-Revert-ath5k-Check-if-pci-pdev-struct-is-initialized.patch
sd@tbox:~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch revert-ath5k-patches/0006-Revert-ath5k-Use-generic-eeprom-read-from-common-ath.patch
patching file drivers/net/wireless/ath/ath5k/ath5k.h
patching file drivers/net/wireless/ath/ath5k/eeprom.c
patching file drivers/net/wireless/ath/ath5k/eeprom.h
patching file drivers/net/wireless/ath/ath5k/pci.c

Now at patch revert-ath5k-patches/0006-Revert-ath5k-Use-generic-eeprom-read-from-common-ath.patch
sd@tbox:~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch revert-ath5k-patches/0007-Revert-ath5k-Move-PCI-bus-functions-to-separate-file.patch
patching file drivers/net/wireless/ath/ath5k/Makefile
patching file drivers/net/wireless/ath/ath5k/ath5k.h
patching file drivers/net/wireless/ath/ath5k/base.c
Hunk #5 succeeded at 3636 (offset 9 lines).
patching file drivers/net/wireless/ath/ath5k/pci.c

Now at patch revert-ath5k-patches/0007-Revert-ath5k-Move-PCI-bus-functions-to-separate-file.patch
sd@tbox:~/src/linux-2.6/linux-2.6.37-rc4/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch revert-ath5k-patches/0008-Revert-ath5k-Introduce-ath5k_init_softc-function-as-.patch
patching file drivers/net/wireless/ath/ath5k/ath5k.h
patching file drivers/net/wireless/ath/ath5k/attach.c
patching file drivers/net/wireless/ath/ath5k/base.c
Hunk #4 FAILED at 2338.
Hunk #5 succeeded at 2530 (offset 1 line).
Hunk #6 succeeded at 2736 (offset 9 lines).
Hunk #7 succeeded at 2745 (offset 9 lines).
Hunk #8 succeeded at 2886 (offset 9 lines).
Hunk #9 succeeded at 2904 (offset 9 lines).
Hunk #10 succeeded at 2916 (offset 9 lines).
Hunk #11 succeeded at 2938 (offset 9 lines).
Hunk #12 succeeded at 3583 (offset 9 lines).
Hunk #13 succeeded at 3617 (offset 9 lines).
Hunk #14 succeeded at 3713 (offset 9 lines).
Hunk #15 succeeded at 3868 (offset 9 lines).
1 out of 15 hunks FAILED -- saving rejects to file
drivers/net/wireless/ath/ath5k/base.c.rej
patching file drivers/net/wireless/ath/ath5k/base.h
patching file drivers/net/wireless/ath/ath5k/eeprom.c
Applied patch revert-ath5k-patches/0008-Revert-ath5k-Introduce-ath5k_init_softc-function-as-.patch
(forced; needs refresh)
- EOT -
