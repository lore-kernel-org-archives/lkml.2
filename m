Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab2KTN1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:27:21 -0500
Received: from void.printf.net ([89.145.121.20]:56686 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab2KTN1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:27:18 -0500
From: Chris Ball <cjb@laptop.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kevin Liu <keyuan.liu@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@ti.com,
        Philip Rakity <prakity@nvidia.com>
Subject: Re: FW: [PATCH v2] mmc: sdhci: apply voltage range check only for non-fixed regulators
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
	<CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
	<50AB34E2.1010206@samsung.com>
	<CADz5_gKdUq8bjuMr1=yo65ysHzLNvKnrfVuSpLk-Q6ek-TWpNA@mail.gmail.com>
	<50AB587F.3040405@samsung.com>
	<CADz5_gJ1hV3n-4BPgBNT9LDp2-E=vNNzMGx=_9PmzT0RJ9+TsA@mail.gmail.com>
	<50AB81C8.4090300@samsung.com>
Date: Tue, 20 Nov 2012 08:27:05 -0500
In-Reply-To: <50AB81C8.4090300@samsung.com> (Marek Szyprowski's message of
	"Tue, 20 Nov 2012 14:12:40 +0100")
Message-ID: <878v9wflqu.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 20 2012, Marek Szyprowski wrote:
>> >> >> Subject: [PATCH v5 03/13] mmc: sdhci: use regulator min/max voltage
>> >> >> range according to spec
>> >> >>
>> >> >> From: Kevin Liu <kliu5@marvell.com>
>> >> >>
>> >> >> For regulator vmmc/vmmcq, use voltage range as below
>> >> >> 3.3v/3.0v: (2.7v, 3.6v)
>> >> >> 1.8v: (1.7v, 1.95v)
>> >> >> Original code use the specific value which may fail in regulator
>> >> >> driver if it does NOT support the specific voltage.
>> >> >>
>> >> >> Signed-off-by: Jialing Fu <jlfu@marvell.com>
>> >> >> Signed-off-by: Kevin Liu <kliu5@marvell.com>
>> >> >
>> >> >
>> >> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> >> >
>> >> > This patch restores sdhci devices to working state on Samsung boards
>> >> > (tested on GONI and UniversalC210) after merging "regulator: fix voltage
>> >> > check in regulator_is_supported_voltage()" patch to v3.7-rc6 (commit
>> >> > f0f98b19e23d4426ca185e3d4ca80e6aff5ef51b). Would be great to have it
>> >> > merged before the final v3.7 is out.
>> >> >
>> >> Marek,
>> >>
>> >> thanks a lot for the verification!
>> >> And your patch "mmc: sdhci: apply voltage range check only for
>> >> non-fixed regulators" (commit
>> >> d5b5205f2d480a47863dda0772d2d9dc47c2b51b, which has been merged in
>> >> mmc-next) can be reverted if this patch merged?
>> >
>> >
>> > Yes, it can be replaced with it, although there is still an issue that need
>> > to be resolved somehow. Right now SDHCI driver fails to initialize if
>> > support
>> > for dummy regulator is enabled.
>> >
>> Then I think the dummy issue can be resolved with your patch merged
>> and if you can just update your patch from
>>       "regulator_count_voltages(host->vmmc) > 1"
>> to
>>       "regulator_count_voltages(host->vmmc) > 0"
>> to let fix regulator work.
>
> regulator_count_voltages() returns 1 for both fixed regulators and for
> virtual dummy regulator, so the above change makes no sense.
>
> However I was so focused on fixing the 2.8V supply case that I missed the
> fact that my "mmc: sdhci: apply voltage range check only for non-fixed
> regulators" patch also fixed the dummy regulator case.
>
> The conclusion is that applying both patches should finally fix the
> regulator issues with for the Samsung boards (2.8V supply for eMMC) and
> 'dummy-regulators' cases.

Thanks, I've pushed v5 of "mmc: sdhci: use regulator min/max voltage
range according to spec" to mmc-next for 3.7 with Marek's Tested-by now.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
