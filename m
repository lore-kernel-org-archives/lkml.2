Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab2KMFNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:13:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58137 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2KMFMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:12:36 -0500
Message-ID: <50A1D6C3.2010108@wwwdotorg.org>
Date: Mon, 12 Nov 2012 22:12:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        John Crispin <blogic@openwrt.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] MIPS: BCM63XX: add empty Device Trees for all supported
 boards
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com> <1352638249-29298-15-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1352638249-29298-15-git-send-email-jonas.gorski@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 05:50 AM, Jonas Gorski wrote:
> Add empty board files for all boards supported by the legacy board
> support.

> diff --git a/arch/mips/bcm63xx/dts/96328avng.dts b/arch/mips/bcm63xx/dts/96328avng.dts

> +/ {
> +	model = "96328avng";
> +	compatible = "96328avng";

The board should be compatible with both the board name and the SoC on
the board. I know that right now the MIPS code is choosing the DT to use
based on the board name, but I think it's more typical to pass an
explicit DT to the kernel, and then choose the kernel support to execute
based on the compatible value (certainly this is the case on ARM and I
assume other architectures too). That would require the DT content to
include the SoC name in the compatible property, so that the kernel
support didn't then need to contain a table of all supported board names.

> +	ubus@10000000 {
> +
> +	};

Do you need to include this empty node in each file? I guess it gets
added to in the next patch so it's not a big deal though.

> diff --git a/arch/mips/bcm63xx/dts/Kconfig b/arch/mips/bcm63xx/dts/Kconfig

> +config BOARD_96328AVNG
> +	bool "96328avng reference board"
> +	select BCM63XX_CPU_6328

Why not simply compile all DTs whenever the SoC support is enabled? I
suppose you're trying to avoid packing all the DTs into the kernel
image. Does it make more sense to amend the MIPS kernel boot process so
that a single user-/firmware-selected DT is passed to the kernel, rather
than packing the DTs into the kernel and selecting one?
