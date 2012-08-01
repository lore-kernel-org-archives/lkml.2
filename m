Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2HAXgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:36:17 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47773 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2HAXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120801220802.GP5470@ics.muni.cz>
References: <20120801133835.GH5470@ics.muni.cz>
	<CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com>
	<CAE9FiQUSFeBpGaFByOfENUa8qg7t89WTiUann8=4ezT7s2qmzw@mail.gmail.com>
	<20120801205640.GN5470@ics.muni.cz>
	<CAE9FiQWmgyirjjCwn54PkAsfvWxZSY5RhRVDkhhbK7E0NPzqaw@mail.gmail.com>
	<20120801220802.GP5470@ics.muni.cz>
Date: Wed, 1 Aug 2012 16:36:14 -0700
X-Google-Sender-Auth: VNQq7f1bVfZ_o3ubKsw9YlEGTJk
Message-ID: <CAE9FiQW84gjtX=_4guCBgcAJmkAGQ5ooFoj7C_29K7QK0s9qwA@mail.gmail.com>
Subject: Re: mellanox mlx4_core and SR-IOV
From: Yinghai Lu <yinghai@kernel.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Roland Dreier <roland@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 3:08 PM, Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> On Wed, Aug 01, 2012 at 02:32:17PM -0700, Yinghai Lu wrote:
>> yes, i knew that.
>>
>> one patch in my for-pci-next should address that.
>>
>> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=patch;h=fcce563f868e296f46a2eeaa88d6959bcee26a2d
>
> this is probably only half-way. well mlx driver loads but it complains again
> on MMIO:
> [    3.564844] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
> [    3.564845] mlx4_core: Initializing 0000:02:00.0
> [    3.564967] mlx4_core 0000:02:00.0: Enabling sriov with:4 vfs
> [    3.565087] mlx4_core 0000:02:00.0: not enough MMIO resources for SR-IOV
> [    3.565402] mlx4_core 0000:02:00.0: Failed to enable sriov,continuing
> without sriov enabled (err = -12).

yes, that is, it will make BAR2 has fallback resource again.

>
> so it seems, that pic=nocsr is a must now.

yes. Or you have bios provide SRIOV support or 64 bit resource in _CRS.

Yinghai
