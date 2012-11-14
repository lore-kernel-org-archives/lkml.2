Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161270Ab2KNUBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:01:22 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35235 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab2KNUBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:01:20 -0500
Date: Wed, 14 Nov 2012 14:51:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2012-11-01
Message-ID: <20121114195152.GE6128@tuxdriver.com>
References: <20121101223750.GA1915@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101223750.GA1915@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 08:37:50PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> Another set of patches for integration in wireless-next. There are two big set
> of changes in it: Andrei Emeltchenko and Mat Martineau added more patches
> towards a full Bluetooth High Speed support and Johan Hedberg improve the
> single mode support for Bluetooth dongles. Apart from that we have small fixes
> and improvements. 
> 
> Please pull. Thanks a lot.
> 
> 	Gustavo
> ---
> 
> The following changes since commit 9917c85b06c2eb9d61c0f2dadd2d5d8788f7e563:
> 
>   brcm80211: remove some truely barftastic code (2012-10-19 16:20:56 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream

Pulled...

> 
> for you to fetch changes up to 0c0afedf55ff409be9db0b0aeeaa1c6fe0f3cd3c:
> 
>   Bluetooth: Fix parameter order of hci_get_route (2012-11-01 20:27:11 -0200)
> 
> ----------------------------------------------------------------
> Andrei Emeltchenko (18):
>       Bluetooth: trivial: Remove unneeded assignment
>       Bluetooth: Use helper function sending EFS conf rsp
>       Bluetooth: AMP: Process Physical Link Complete evt
>       Bluetooth: AMP: Process Logical Link complete evt
>       Bluetooth: Add put(hcon) when deleting hchan
>       Bluetooth: trivial: Fix braces style and remove empty line
>       Bluetooth: Save hs_hchan instead of hs_hcon in loglink complete
>       Bluetooth: Return correct L2CAP response type
>       Bluetooth: Derive remote and local amp id from chan struct
>       Bluetooth: AMP: Add Logical Link Create function
>       Bluetooth: AMP: Process Disc Logical Link
>       Bluetooth: AMP: Process Disc Physical Link Complete evt
>       Bluetooth: AMP: Remove hci_conn receiving error command status
>       Bluetooth: Disconnect logical link when deleting chan
>       Bluetooth: AMP: Check for hs_hcon instead of ctrl_id
>       Bluetooth: AMP: Use l2cap_physical_cfm in phylink complete evt
>       Bluetooth: Process Create Chan Request
>       Bluetooth: Rename ctrl_id to remote_amp_id
> 
> Denis Kirjanov (1):
>       Bluetooth:Replace list_for_each with list_for_each_entry() helper
> 
> Gustavo Padovan (1):
>       Bluetooth: Replace *_init() for *_setup()
> 
> Johan Hedberg (16):
>       Bluetooth: Add initial support for LE-only controllers
>       Bluetooth: Fix LE MTU reporting for HCIGETDEVINFO
>       Bluetooth: Add setting of the LE event mask
>       Bluetooth: Read adversiting channel TX power during init sequence
>       Bluetooth: Fix HCI command sending when powering on LE-only adapters
>       Bluetooth: mgmt: Restrict BR/EDR settings to BR/EDR-only adapters
>       Bluetooth: Fix updating host feature bits for LE
>       Bluetooth: Add missing feature test macros
>       Bluetooth: Make use feature test macros
>       Bluetooth: Add flag for LE GAP Peripheral role
>       Bluetooth: Disallow LE scanning and connecting in peripheral role
>       Bluetooth: Fix setting host feature bits for SSP
>       Bluetooth: Fix sending unnecessary HCI_Write_SSP_Mode command
>       Bluetooth: Fix unnecessary EIR update during powering on
>       Bluetooth: Fix sending unnecessary HCI_LE_Host_Enable
>       Bluetooth: Fix parameter order of hci_get_route
> 
> Mat Martineau (18):
>       Bluetooth: Add new l2cap_chan struct members for high speed channels
>       Bluetooth: Add L2CAP create channel request handling
>       Bluetooth: Remove unnecessary intermediate function
>       Bluetooth: Lookup channel structure based on DCID
>       Bluetooth: Channel move request handling
>       Bluetooth: Add new ERTM receive states for channel move
>       Bluetooth: Add move channel confirm handling
>       Bluetooth: Add state to hci_chan
>       Bluetooth: Move channel response
>       Bluetooth: Add logical link confirm
>       Bluetooth: Add move confirm response handling
>       Bluetooth: Handle physical link completion
>       Bluetooth: Flag ACL frames as complete for AMP controllers
>       Bluetooth: Do not send data during channel move
>       Bluetooth: Configure appropriate timeouts for AMP controllers
>       Bluetooth: Ignore BR/EDR packet size constraints when fragmenting for AMP
>       Bluetooth: Do not retransmit data during a channel move
>       Bluetooth: Start channel move when socket option is changed
> 
> Syam Sidhardhan (4):
>       Bluetooth: trivial: Remove newline before EOF
>       Bluetooth: Replace include linux/module.h with linux/export.h
>       Bluetooth: Remove unnecessary include export.h
>       Bluetooth: mgmt: Use __constant when dealing with constants
> 
>  include/net/bluetooth/amp.h      |    4 +
>  include/net/bluetooth/hci.h      |    7 +
>  include/net/bluetooth/hci_core.h |   44 +-
>  include/net/bluetooth/l2cap.h    |   38 +-
>  net/bluetooth/Kconfig            |    1 -
>  net/bluetooth/a2mp.c             |    4 +-
>  net/bluetooth/amp.c              |   93 ++++
>  net/bluetooth/bnep/netdev.c      |    1 -
>  net/bluetooth/cmtp/capi.c        |    2 +-
>  net/bluetooth/cmtp/sock.c        |    2 +-
>  net/bluetooth/hci_conn.c         |    6 +
>  net/bluetooth/hci_core.c         |   65 +--
>  net/bluetooth/hci_event.c        |  309 +++++++++++--
>  net/bluetooth/l2cap_core.c       | 1000 +++++++++++++++++++++++++++++++++++++---
>  net/bluetooth/l2cap_sock.c       |    5 +
>  net/bluetooth/mgmt.c             |   98 ++--
>  16 files changed, 1486 insertions(+), 193 deletions(-)



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
