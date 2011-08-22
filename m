Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1HVW46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:56:58 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55935 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1HVW44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:56:56 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B24A3687@HQMAIL01.nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A3687@HQMAIL01.nvidia.com>
Date: Mon, 22 Aug 2011 15:56:55 -0700
Message-ID: <CAOesGMhGb1-sOaBU4oaa_8-1triS01tOmseJqYyCm849feLhXg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 12:56 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Stephen Warren wrote at Monday, August 15, 2011 2:28 PM:
>> ...
>> This patch modifies Tegra's device tree support to remove the dependency
>> on harmony_pinmux_init(), thus making it completely board-independent.
>
> I had the good fortune of meeting Grant at LinuxCon last week and talked
> through this patchset a little (thanks!)
>
> The message I got from Grant was that the patches are basically OK. He
> did have a couple of concerns:
>
> * Does this cause the compiled DTB to blow up in size.
>
> The DTB goes from ~3-4K to ~8-9K with these patches added. While that
> is a large % increase, Grant said that as an absolute value, that size
> shouldn't be an issue.

Agreed, especially if compared with the size of the current in-kernel table.

> * There's lots of repetition in the .dts representation; can this be improved?
>
[...]
> meaningless-name { // typically would just use the pin name
>    pins = "ld0", "ld1", "ld2", ...;
>    nvidia,function = "displaya";
>    nvidia,pull-down;
> };

That sounds quite close to what I was thinking about earlier (with
s/meaningless-name/displaya/ in the above example).

> * We also briefly discussed that dtc could be modified to support symbolic
> constants, so we could use named integers for the function names (perhaps
> pin names too). I'll look into how easy it is to modify dtc for this.

That'd be useful, I think -- there's still the whole issue of the same
pin function being at different mux locations on different pin groups,
so an integer representation might not work.

> I'll look into implementing these enhancements, and others discussed in
> this email thread, and repost.

Cool.


-Olof
