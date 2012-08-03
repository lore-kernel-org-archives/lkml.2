Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2HCIeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 04:34:01 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:53905 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab2HCId5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:33:57 -0400
Date: Fri, 3 Aug 2012 10:33:44 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Roland Dreier <roland@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: mellanox mlx4_core and SR-IOV
Message-ID: <20120803083344.GF25979@ics.muni.cz>
References: <20120801133835.GH5470@ics.muni.cz>
 <CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com>
 <CAE9FiQUSFeBpGaFByOfENUa8qg7t89WTiUann8=4ezT7s2qmzw@mail.gmail.com>
 <20120801205640.GN5470@ics.muni.cz>
 <CAE9FiQWmgyirjjCwn54PkAsfvWxZSY5RhRVDkhhbK7E0NPzqaw@mail.gmail.com>
 <20120801220802.GP5470@ics.muni.cz>
 <CAE9FiQW84gjtX=_4guCBgcAJmkAGQ5ooFoj7C_29K7QK0s9qwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQW84gjtX=_4guCBgcAJmkAGQ5ooFoj7C_29K7QK0s9qwA@mail.gmail.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 94.112.253.31
X-Muni-Envelope-From: xhejtman@ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 03 Aug 2012 10:33:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 04:36:14PM -0700, Yinghai Lu wrote:
> > so it seems, that pic=nocsr is a must now.
> 
> yes. Or you have bios provide SRIOV support or 64 bit resource in _CRS.

Well, I can use PCI passthrough in Xen now, however, it seems SR-IOV does not
work in case of Mellanox mlx4 driver.

With 3.5 stock kernel, I got this message in virtual domain:
[    2.666623] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
[    2.666635] mlx4_core: Initializing 0000:00:00.1
[    2.666717] mlx4_core 0000:00:00.1: enabling device (0000 -> 0002)
[    2.666975] mlx4_core 0000:00:00.1: Xen PCI mapped GSI0 to IRQ168
[    2.667040] mlx4_core 0000:00:00.1: enabling bus mastering
[    2.667184] mlx4_core 0000:00:00.1: Detected virtual function - running in slave mode
[    2.667214] mlx4_core 0000:00:00.1: Sending reset
[    2.667319] mlx4_core 0000:00:00.1: Sending vhcr0
[    2.667886] mlx4_core 0000:00:00.1: HCA minimum page size:1
[    2.668067] mlx4_core 0000:00:00.1: The host doesn't support eth interface
[    2.668074] mlx4_core 0000:00:00.1: QUERY_FUNC_CAP command failed, aborting.
[    2.668079] mlx4_core 0000:00:00.1: Failed to obtain slave caps
[    2.668305] mlx4_core: probe of 0000:00:00.1 failed with error -93

not sure what does it mean.

I also tried OFED package from Mellanox which seems to have better SR-IOV
support (at least mlx4_ib does not complain that SR-IOV is not supported).
However, it does not work when SR-IOV enabled:
[13677.034266] mlx4_core 0000:02:00.0: Running in master mode
[13689.278238] mlx4_core 0000:02:00.0: command 0x31 timed out (go bit not cleared)
[13689.278324] mlx4_core 0000:02:00.0: NOP command failed to generate MSI-X interrupt IRQ 241).
[13689.278399] mlx4_core 0000:02:00.0: Trying again without MSI-X.
[13699.286473] mlx4_core 0000:02:00.0: command 0x31 timed out (go bit not cleared)
[13699.286557] mlx4_core 0000:02:00.0: NOP command failed to generate interrupt (IRQ 237), aborting.
[13699.286633] mlx4_core 0000:02:00.0: BIOS or ACPI interrupt routing problem?
[13701.406680] mlx4_core: probe of 0000:02:00.0 failed with error -16

if I disable SR-IOV mode for this driver, it works OK. Could the interrupt
problem be BIOS related? I.e., it won't work until I got BIOS which properly
supports SR-IOV with Mellanox card?

-- 
Luká¹ Hejtmánek
