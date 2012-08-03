Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2HCQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:41:33 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58506 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2HCQlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:41:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120803083344.GF25979@ics.muni.cz>
References: <20120801133835.GH5470@ics.muni.cz>
	<CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com>
	<CAE9FiQUSFeBpGaFByOfENUa8qg7t89WTiUann8=4ezT7s2qmzw@mail.gmail.com>
	<20120801205640.GN5470@ics.muni.cz>
	<CAE9FiQWmgyirjjCwn54PkAsfvWxZSY5RhRVDkhhbK7E0NPzqaw@mail.gmail.com>
	<20120801220802.GP5470@ics.muni.cz>
	<CAE9FiQW84gjtX=_4guCBgcAJmkAGQ5ooFoj7C_29K7QK0s9qwA@mail.gmail.com>
	<20120803083344.GF25979@ics.muni.cz>
Date: Fri, 3 Aug 2012 09:41:07 -0700
X-Google-Sender-Auth: 0oXepFhhMhz2FmWOQ8n8XFQes70
Message-ID: <CAE9FiQX+dQiJXS31mXky4WSNHbmwNzHEwm3YhbWnmObWJ-FBug@mail.gmail.com>
Subject: Re: mellanox mlx4_core and SR-IOV
From: Yinghai Lu <yinghai@kernel.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Roland Dreier <roland@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 1:33 AM, Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> On Wed, Aug 01, 2012 at 04:36:14PM -0700, Yinghai Lu wrote:
>> > so it seems, that pic=nocsr is a must now.
>>
>> yes. Or you have bios provide SRIOV support or 64 bit resource in _CRS.
>
> Well, I can use PCI passthrough in Xen now, however, it seems SR-IOV does not
> work in case of Mellanox mlx4 driver.
>
> With 3.5 stock kernel, I got this message in virtual domain:
> [    2.666623] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
> [    2.666635] mlx4_core: Initializing 0000:00:00.1
> [    2.666717] mlx4_core 0000:00:00.1: enabling device (0000 -> 0002)
> [    2.666975] mlx4_core 0000:00:00.1: Xen PCI mapped GSI0 to IRQ168
> [    2.667040] mlx4_core 0000:00:00.1: enabling bus mastering
> [    2.667184] mlx4_core 0000:00:00.1: Detected virtual function - running in slave mode
> [    2.667214] mlx4_core 0000:00:00.1: Sending reset
> [    2.667319] mlx4_core 0000:00:00.1: Sending vhcr0
> [    2.667886] mlx4_core 0000:00:00.1: HCA minimum page size:1
> [    2.668067] mlx4_core 0000:00:00.1: The host doesn't support eth interface
> [    2.668074] mlx4_core 0000:00:00.1: QUERY_FUNC_CAP command failed, aborting.
> [    2.668079] mlx4_core 0000:00:00.1: Failed to obtain slave caps
> [    2.668305] mlx4_core: probe of 0000:00:00.1 failed with error -93
>
> not sure what does it mean.

did you check if SRIOV bar for that card is assigned in DOM0 ?

can you kvm with pci pass through?

I only tried pci through with intel igb and ixgbe sriov device with
kvm recently.

please make sure you have intel_iommu=on ...

Thanks

Yinghai
