Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab0LGQUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:20:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33279 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab0LGQUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:20:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ZX6rK7SwBGyFQsqMwsubyZzZTUKt7NsRM9KoKpT5lU+bxGqrvAI2mjc0tjz0AB/HKC
         h/MYby4zZ8vwi5zKNHfdjqiv4swqMQxrhViPaThD+4TckwyJrY5USwpd+cfaEHMYvoBn
         AAtX7X3pQ8LSk84aaZNZp7lbHxgyUP7fMTZJE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101207155924.GC2700@tuxdriver.com>
References: <AANLkTik1P7vQbgL8qxoTEEyR0D0cTV+9zsBcHT3L_nwm@mail.gmail.com>
	<20101207142639.GB2700@tuxdriver.com>
	<AANLkTinjx-+Fv-1CKx6pJwx2FcxiH7skEsqDQtETtBUT@mail.gmail.com>
	<20101207155924.GC2700@tuxdriver.com>
Date: Tue, 7 Dec 2010 17:20:32 +0100
Message-ID: <AANLkTi=37TKAh2R47oObDoHw3vWb+i60jJJu6m1Vh=kZ@mail.gmail.com>
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

On Tue, Dec 7, 2010 at 4:59 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Dec 07, 2010 at 04:57:08PM +0100, Sedat Dilek wrote:
>> On Tue, Dec 7, 2010 at 3:26 PM, John W. Linville <linville@tuxdriver.com> wrote:
>> > On Tue, Dec 07, 2010 at 12:24:14PM +0100, Sedat Dilek wrote:
>> >
>> >> I have already reported on linux-wireless (short: l-w) ML that after
>> >> especially the merge of "AHB Bus support" patchset (see [2]) my ath5k
>> >> was not working as expected in daily use (also modinfo).
>> >>
>> >> I am not sure if it is the driver but reverting the 9 commits in my
>> >> local linux-next GIT seemed to "stabilize" a bit the Internet
>> >> connection.
>> >> The patchset from Nick (see below) definitely helped to stabilize ath5k.
>> >
>> > I imagine that these are the "9 commits" you mean:
>> >
>> >> git rev-list c30ae13..4cebb34
>> > 4cebb34caa5122216a1e2451eae9e0fc47ec2589
>> > a0b907ee2a71052fefdf6151764095f3f97b3275
>> > c31b5c9c806b1fbdc9e98885d897664a0d482989
>> > e7aecd327d80b2f156b54769013aaccb2a20645a
>> > 8efa5d7d6ad307ae2d220def37ca89594062c40d
>> > 4aa5d783c9e1c72e4950ff34f388077ccecac74a
>> > e5b046d86fac609f636d127a38de94a175c7e83b
>> > 132b1c3ee38ea6fa0501004fd0f19acb554e5a44
>> > aeae4ac9090462ea38387dcdbac4f01b944af6a4
>> >
>> > Most of those look fairly harmless so long as you don't define
>> > CONFIG_ATHEROS_AR231X.  Just to narrow things down...if you only revert
>> > the first 8 (i.e. leave aeae4ac alone), do you still have problems?
>> > Or does it still "stabilize"?
>> >
>> > That patch converts the driver to the generic DMA API.  It seems
>> > OK at first glance, but I suspect it is the only one likely to be
>> > effecting your situation.
>> >
>> > John
>> > --
>> > John W. Linville                Someday the world will need a hero, and you
>> > linville@tuxdriver.com                  might be all we have.  Be ready.
>> >
>>
>> Before jumping to another problem, I had a quick look into the
>> appropriate Kconfig file, as you say I have not CONFIG_ATHEROS_AR231X
>> set and that's why AHB support is not selected/built, instead
>>
>>   CC [M]  drivers/net/wireless/ath/ath5k/pci.o
>>
>> is built.
>>
>> Unfortunately, I can't cleanly revert. Sorry, I can't help.
>
> I don't quite understand -- you said you were reverting them before,
> but now I ask you to revert one _less_ patch (i.e. the last one to
> be reverted anyway) and you can't do it?
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>

After AHB-support patches went into linux-next (next-20101207), there
are now new ath5k patches touching
"drivers/net/wireless/ath/ath5k/base.c" on top.
For example the patchset from Nick, this would mean revert them, too.
Doing so, won't give you a clear answer.

BTW, 0008 patch has a big change:

 drivers/net/wireless/ath/ath5k/base.c   |  344 +++++++++++++------------------

Another solution would be to take a previous linux-next where those
patches were not in.
As you say by yourself 0001..0008 do not hurt, it's 0009 patch (first
in patchset) you are speculating on.

As I have archived my "compiled" build-trees, I can look at them.
AFAICS linux-next (next-20101203) should have wireless-next-2.6
(master-2010-12-02) [1] included.
Also, I have to find the fitting linux-image binary and install it,
hope I have not purged it from hdd.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=shortlog;h=refs/tags/master-2010-12-02

$ ls revert-ath5k-patches/000*
revert-ath5k-patches/0001-Revert-ath5k-Fix-reset-and-interrupts-for-AHB-type-o.patch
revert-ath5k-patches/0002-Revert-ath5k-Add-AHB-bus-support.patch
revert-ath5k-patches/0003-Revert-ath5k-Add-initial-registers-values-for-radio-.patch
revert-ath5k-patches/0004-Revert-ath5k-Add-a-function-to-read-chipset-s-MAC-re.patch
revert-ath5k-patches/0005-Revert-ath5k-Check-if-pci-pdev-struct-is-initialized.patch
revert-ath5k-patches/0006-Revert-ath5k-Use-generic-eeprom-read-from-common-ath.patch
revert-ath5k-patches/0007-Revert-ath5k-Move-PCI-bus-functions-to-separate-file.patch
revert-ath5k-patches/0008-Revert-ath5k-Introduce-ath5k_init_softc-function-as-.patch
revert-ath5k-patches/0009-Revert-ath5k-Use-Generic-DMA-for-later-support-of-AH.patch
