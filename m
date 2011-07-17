Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1GQOg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 10:36:29 -0400
Received: from mail001.aei.ca ([206.123.6.130]:55976 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892Ab1GQOg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 10:36:26 -0400
From: Ed Tomlinson <edt@aei.ca>
To: David Miller <davem@davemloft.net>
Subject: Re: [GIT] Networking
Date: Sun, 17 Jul 2011 10:36:17 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc7-crc+; KDE/4.6.5; x86_64; ; )
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110716.104325.1217042780857481057.davem@davemloft.net>
In-Reply-To: <20110716.104325.1217042780857481057.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107171036.18470.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 July 2011 13:43:25 David Miller wrote:
> 
> A small batch of fixes:
> 
> 1) Fix two regressions in checksum offload handling.
>    a) Do not set SCTP packets to CHECKSUM_UNNECESSARY, we don't
>       have software fallbacks in the TX path for SCTP checksumming
>       and therefore won't be able to handle a divert of a packet
>       from a device that can do SCTP checksums to one that cannot.
>    b) We propagate certain hardware offloads transparently through
>       "software" devices (like vlan and bonding) but we cannot do
>       that when we lack software fallbacks in the TX path and this
>       is relevant for SCTP and FCoE checksumming.  Get rid of the
>       NETIF_F_ALL_TX_OFFLOADS macro since it's misuse is what
>       introduced this regression.
> 
> 2) L2CAP bluetooth connection procedure regression fix from
>    Gustavo F. Padovan.
> 
> 3) L2CAP incomming connections can crash with defer_setup enabled
>    because ->parent isn't setup yet, handle that properly.  Also
>    from Gustavo.
> 
> 4) gianfar driver need to be more selective of when the RX parser
>    of the chip is enabled, from Sebastian Poehn.
> 
> 5) r6040 NAPI logic has a bug that can disabled interrupts forever,
>    fix from Michael Thalmeier.
> 
> Please pull, thanks a lot!
> 
> The following changes since commit 1765a367a3b5d5e9692949b0c5ec933eff2c0701:
> 
>   Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-07-15 18:03:30 -0700)
> 
> are available in the git repository at:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master
> 
> Gustavo F. Padovan (1):
>       Bluetooth: Fix regression in L2CAP connection procedure
> 
> Ilia Kolomisnky (1):
>       Bluetooth: Fix crash with incoming L2CAP connections
> 
> Michael Thalmeier (1):
>       r6040: only disable RX interrupt if napi_schedule_prep is successful
> 
> Michał Mirosław (2):
>       net: sctp: fix checksum marking for outgoing packets
>       net: remove NETIF_F_ALL_TX_OFFLOADS
> 
> Sebastian Pöhn (1):
>       gianfar: rx parser
> 
>  drivers/net/bonding/bond_main.c |    6 +++---
>  drivers/net/gianfar.c           |   24 +++++++++++++++++++-----
>  drivers/net/gianfar.h           |    3 ++-
>  drivers/net/r6040.c             |    8 +++++---
>  include/linux/netdevice.h       |    6 ------
>  net/8021q/vlan_dev.c            |    6 +++++-
>  net/bluetooth/l2cap_core.c      |    9 +++++----
>  net/sctp/output.c               |   19 ++++++++-----------
>  8 files changed, 47 insertions(+), 34 deletions(-)

This just to confirm that Gustavo's fixes correct the problems reported in thread: "[BUG] Bluetooth broken post rc7"

Ed 
