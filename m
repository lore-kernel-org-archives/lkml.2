Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161209Ab2KNMPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:15:48 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49618 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161153Ab2KNMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:15:47 -0500
MIME-Version: 1.0
In-Reply-To: <50A1D6C3.2010108@wwwdotorg.org>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
 <1352638249-29298-15-git-send-email-jonas.gorski@gmail.com> <50A1D6C3.2010108@wwwdotorg.org>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Wed, 14 Nov 2012 13:15:26 +0100
Message-ID: <CAOiHx=mJ70_DAzJOHHc_h04Ut7NXtXcwuHS4GYfQqJsrjt=mCA@mail.gmail.com>
Subject: Re: [RFC] MIPS: BCM63XX: add empty Device Trees for all supported boards
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        John Crispin <blogic@openwrt.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2012 06:12, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/11/2012 05:50 AM, Jonas Gorski wrote:
>> Add empty board files for all boards supported by the legacy board
>> support.
>
>> diff --git a/arch/mips/bcm63xx/dts/96328avng.dts b/arch/mips/bcm63xx/dts/96328avng.dts
>
>> +/ {
>> +     model = "96328avng";
>> +     compatible = "96328avng";
>
> The board should be compatible with both the board name and the SoC on
> the board. I know that right now the MIPS code is choosing the DT to use
> based on the board name, but I think it's more typical to pass an
> explicit DT to the kernel, and then choose the kernel support to execute
> based on the compatible value (certainly this is the case on ARM and I
> assume other architectures too). That would require the DT content to
> include the SoC name in the compatible property, so that the kernel
> support didn't then need to contain a table of all supported board names.

I'll add the SoC name to the compatible line.

>> +     ubus@10000000 {
>> +
>> +     };
>
> Do you need to include this empty node in each file? I guess it gets
> added to in the next patch so it's not a big deal though.

It's just there so it is already present when adding blocks to it. It
is/was mainly for making reordering patches easier.

>
>> diff --git a/arch/mips/bcm63xx/dts/Kconfig b/arch/mips/bcm63xx/dts/Kconfig
>
>> +config BOARD_96328AVNG
>> +     bool "96328avng reference board"
>> +     select BCM63XX_CPU_6328
>
> Why not simply compile all DTs whenever the SoC support is enabled? I
> suppose you're trying to avoid packing all the DTs into the kernel
> image. Does it make more sense to amend the MIPS kernel boot process so
> that a single user-/firmware-selected DT is passed to the kernel, rather
> than packing the DTs into the kernel and selecting one?

The plan is to add support for an externally attached DT (but not
present yet), and eventually add support for a bootloader passed DT,
but since I don't know yet how these will work, I didn't want to add
something based on guesses.

My reasoning for allowing (de-)selecting each board is to dampen the
bloat from the dtbs - after these few blocks the combined dtbs are
already four times as large as the old board setup code including all
boards. Especially older devices are constrained to 4 or even 2 MB
flash, so every kB counts there.


Jonas
