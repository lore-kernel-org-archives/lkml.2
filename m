Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1BWRgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:36:14 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6121 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab1BWRgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:36:13 -0500
Message-ID: <4D65458D.5080908@caviumnetworks.com>
Date: Wed, 23 Feb 2011 09:36:13 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/10] MIPS: Octeon: Move some Ethernet support files
 out of staging.
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com> <1298408274-20856-2-git-send-email-ddaney@caviumnetworks.com> <20110223144805.GC3143@angua.secretlab.ca>
In-Reply-To: <20110223144805.GC3143@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 17:36:13.0523 (UTC) FILETIME=[2AA9B230:01CBD380]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 06:48 AM, Grant Likely wrote:
> On Tue, Feb 22, 2011 at 12:57:45PM -0800, David Daney wrote:
>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>
> If this is an Ethernet driver, then it belongs in drivers/net and you
> should cc both netdev and Dave Miller.
>

Eventually the files need to go somewhere other than drivers/staging. 
They are not all Ethernet related, so sorting out exactly where they all 
go is not so simple.  This subject has been a thorn in my side for quite 
some time.

For the sake of getting the Device Tree patching code working and to 
generate Device Tree related feedback, I moved them to be with their kin 
in arch/mips/cavium-octeon/executive.

In the context of this patch set, I consider this to be a somewhat minor 
detail.

David Daney

> g.
>
>> ---
>>   arch/mips/cavium-octeon/executive/Makefile         |    5 +
>>   .../mips/cavium-octeon/executive}/cvmx-cmd-queue.c |    8 +-
>>   .../mips/cavium-octeon/executive}/cvmx-fpa.c       |    0
>>   .../cavium-octeon/executive}/cvmx-helper-board.c   |   18 +--
>>   .../cavium-octeon/executive}/cvmx-helper-fpa.c     |    0
>>   .../cavium-octeon/executive}/cvmx-helper-loop.c    |    6 +-
>>   .../cavium-octeon/executive}/cvmx-helper-npi.c     |    6 +-
>>   .../cavium-octeon/executive}/cvmx-helper-rgmii.c   |   17 +-
>>   .../cavium-octeon/executive}/cvmx-helper-sgmii.c   |   12 +-
>>   .../cavium-octeon/executive}/cvmx-helper-spi.c     |   10 +-
>>   .../cavium-octeon/executive}/cvmx-helper-util.c    |   16 +-
>>   .../cavium-octeon/executive}/cvmx-helper-xaui.c    |   10 +-
>>   .../mips/cavium-octeon/executive}/cvmx-helper.c    |   27 ++--
>>   .../executive}/cvmx-interrupt-decodes.c            |   10 +-
>>   .../cavium-octeon/executive}/cvmx-interrupt-rsl.c  |    4 +-
>>   .../mips/cavium-octeon/executive}/cvmx-pko.c       |    6 +-
>>   .../mips/cavium-octeon/executive}/cvmx-spi.c       |   12 +-
>>   .../mips/include/asm}/octeon/cvmx-address.h        |    0
>>   .../mips/include/asm}/octeon/cvmx-asxx-defs.h      |    0
>>   .../mips/include/asm}/octeon/cvmx-cmd-queue.h      |    0
>>   .../mips/include/asm}/octeon/cvmx-config.h         |    0
>>   .../mips/include/asm}/octeon/cvmx-dbg-defs.h       |    0
>>   .../mips/include/asm}/octeon/cvmx-fau.h            |    0
>>   .../mips/include/asm}/octeon/cvmx-fpa-defs.h       |    0
>>   .../mips/include/asm}/octeon/cvmx-fpa.h            |    0
>>   .../mips/include/asm}/octeon/cvmx-gmxx-defs.h      |    0
>>   .../mips/include/asm}/octeon/cvmx-helper-board.h   |    0
>>   .../mips/include/asm}/octeon/cvmx-helper-fpa.h     |    0
>>   .../mips/include/asm}/octeon/cvmx-helper-loop.h    |    0
>>   .../mips/include/asm}/octeon/cvmx-helper-npi.h     |    0
>>   .../mips/include/asm}/octeon/cvmx-helper-rgmii.h   |    0
>>   .../mips/include/asm}/octeon/cvmx-helper-sgmii.h   |    0
>>   .../mips/include/asm}/octeon/cvmx-helper-spi.h     |    0
>>   .../mips/include/asm}/octeon/cvmx-helper-util.h    |    0
>>   .../mips/include/asm}/octeon/cvmx-helper-xaui.h    |    0
>>   .../mips/include/asm}/octeon/cvmx-helper.h         |    0
>>   .../mips/include/asm}/octeon/cvmx-ipd.h            |    0
>>   .../mips/include/asm}/octeon/cvmx-mdio.h           |    0
>>   .../mips/include/asm}/octeon/cvmx-pcsx-defs.h      |    0
>>   .../mips/include/asm}/octeon/cvmx-pcsxx-defs.h     |    0
>>   .../mips/include/asm}/octeon/cvmx-pip-defs.h       |    0
>>   .../mips/include/asm}/octeon/cvmx-pip.h            |    0
>>   .../mips/include/asm}/octeon/cvmx-pko-defs.h       |    0
>>   .../mips/include/asm}/octeon/cvmx-pko.h            |    0
>>   .../mips/include/asm}/octeon/cvmx-pow.h            |    0
>>   .../mips/include/asm}/octeon/cvmx-scratch.h        |    0
>>   .../mips/include/asm}/octeon/cvmx-spi.h            |    0
>>   .../mips/include/asm}/octeon/cvmx-spxx-defs.h      |    0
>>   .../mips/include/asm}/octeon/cvmx-srxx-defs.h      |    0
>>   .../mips/include/asm}/octeon/cvmx-stxx-defs.h      |    0
>>   .../mips/include/asm}/octeon/cvmx-wqe.h            |    0
>>   drivers/staging/octeon/Makefile                    |    5 -
>>   drivers/staging/octeon/cvmx-packet.h               |   65 -------
>>   drivers/staging/octeon/cvmx-smix-defs.h            |  178 --------------------
>>   drivers/staging/octeon/ethernet-defines.h          |    2 +-
>>   drivers/staging/octeon/ethernet-mdio.c             |    4 +-
>>   drivers/staging/octeon/ethernet-mem.c              |    2 +-
>>   drivers/staging/octeon/ethernet-rgmii.c            |    4 +-
>>   drivers/staging/octeon/ethernet-rx.c               |   14 +-
>>   drivers/staging/octeon/ethernet-rx.h               |    2 +-
>>   drivers/staging/octeon/ethernet-sgmii.c            |    4 +-
>>   drivers/staging/octeon/ethernet-spi.c              |    6 +-
>>   drivers/staging/octeon/ethernet-tx.c               |   12 +-
>>   drivers/staging/octeon/ethernet-xaui.c             |    4 +-
>>   drivers/staging/octeon/ethernet.c                  |   14 +-
>>   65 files changed, 116 insertions(+), 367 deletions(-)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-cmd-queue.c (98%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-fpa.c (100%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper-board.c (98%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper-fpa.c (100%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper-loop.c (95%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper-npi.c (96%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper-rgmii.c (97%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper-sgmii.c (98%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper-spi.c (97%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper-util.c (97%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper-xaui.c (98%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-helper.c (98%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-interrupt-decodes.c (98%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-interrupt-rsl.c (97%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-pko.c (99%)
>>   rename {drivers/staging/octeon =>  arch/mips/cavium-octeon/executive}/cvmx-spi.c (99%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-address.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-asxx-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-cmd-queue.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-config.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-dbg-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-fau.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-fpa-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-fpa.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-gmxx-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper-board.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper-fpa.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper-loop.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper-npi.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper-rgmii.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper-sgmii.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper-spi.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper-util.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper-xaui.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-helper.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-ipd.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-mdio.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-pcsx-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-pcsxx-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-pip-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-pip.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-pko-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-pko.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-pow.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-scratch.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-spi.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-spxx-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-srxx-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-stxx-defs.h (100%)
>>   rename {drivers/staging =>  arch/mips/include/asm}/octeon/cvmx-wqe.h (100%)
>>   delete mode 100644 drivers/staging/octeon/cvmx-packet.h
>>   delete mode 100644 drivers/staging/octeon/cvmx-smix-defs.h
>>

