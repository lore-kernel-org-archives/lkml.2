Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab2EPSSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:18:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51317 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081Ab2EPSRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:17:50 -0400
Date: Wed, 16 May 2012 14:09:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2012-05-16
Message-ID: <20120516180924.GA28167@tuxdriver.com>
References: <20120516155340.GC1414@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516155340.GC1414@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:53:40PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> A big pull request for inclusion in 3.5. In this set there is some changes
> regarding periodic scan and LE, endian fixes, L2CAP ERTM improvements. There
> is also fixes, clean ups and small improvements all over the tree.
> I also included the patches rejected in the bluetooth pull request.
> 
> I checked the whole diff of this pull request for offending coding style
> changes and couldn't spot anything wrong.
> 
> I merged wireless/master into this.
> 
> Please pull, or let me know of any problems!
> 
> 	Gustavo
> 
> ---
> 
> The following changes since commit 341352d13dae752610342923c53ebe461624ee2c:
> 
>   iwlwifi: fix-up some merge damage from commit 0d6c4a2 (2012-05-08 22:18:09 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to cde5b476786450fb058a23502372d63c3e8629d0:
> 
>   Bluetooth: Report proper error number in disconnection (2012-05-16 18:44:35 +0300)
> 
> ----------------------------------------------------------------
> Amitkumar Karwar (2):
>       Bluetooth: btmrvl: configure default host sleep parameters
>       Bluetooth: btmrvl: add support for SDIO suspend/resume callbacks
> 
> Andre Guedes (21):
>       Bluetooth: Check FINDING state in interleaved discovery
>       Bluetooth: Add hci_cancel_le_scan() to hci_core
>       Bluetooth: LE support for MGMT stop discovery
>       Bluetooth: Replace EPERM by EALREADY in hci_cancel_inquiry
>       Bluetooth: Refactor stop_discovery
>       Bluetooth: Add Periodic Inquiry command complete handler
>       Bluetooth: Add HCI_PERIODIC_INQ to dev_flags
>       Bluetooth: Check HCI_PERIODIC_INQ in start_discovery
>       Bluetooth: Ignore inquiry results from periodic inquiry
>       Bluetooth: Add Periodic Inquiry command complete handler
>       Bluetooth: Add HCI_PERIODIC_INQ to dev_flags
>       Bluetooth: Remove MGMT_ADDR_INVALID macro
>       Bluetooth: Remove useless code in hci_connect
>       Bluetooth: Move address type macros to bluetooth.h
>       Bluetooth: Rename link_to_mgmt to link_to_bdaddr
>       Bluetooth: Add address type to struct sockaddr_l2
>       Bluetooth: Rename mgmt_to_le to bdaddr_to_le
>       Bluetooth: Move bdaddr_to_le to hci_core
>       Bluetooth: Add dst_type parameter to hci_connect
>       Bluetooth: Use address type info from user-space
>       Bluetooth: Remove advertising cache
> 
> Andrei Emeltchenko (24):
>       Bluetooth: trivial: Correct endian conversion
>       Bluetooth: Correct type for hdev lmp_subver
>       Bluetooth: Correct type for ediv to __le16
>       Bluetooth: Fix extra conversion to __le32
>       Bluetooth: Correct chan->psm endian conversions
>       Bluetooth: Correct ediv in SMP
>       Bluetooth: Correct length calc in L2CAP conf rsp
>       Bluetooth: Correct CID endian notation
>       Bluetooth: Convert error codes to le16
>       Bluetooth: trivial: Fix endian conversion mode
>       Bluetooth: trivial: Correct types
>       Bluetooth: Fix type in cpu_to_le conversion
>       Bluetooth: Fix opcode access in hci_complete
>       Bluetooth: trivial: Remove sparse warnings
>       Bluetooth: Silence sparse warning
>       Bluetooth: Comments and style fixes
>       Bluetooth: Remove unneeded timer clear
>       Bluetooth: Make L2CAP chan_add functions static
>       Bluetooth: Remove unneeded zero initialization
>       Bluetooth: Add Read Local AMP Info to init
>       Bluetooth: Adds set_default function in L2CAP setup
>       Bluetooth: Fix debug printing unallocated name
>       Bluetooth: trivial: Remove empty line
>       Bluetooth: Remove unneeded calculation and magic number
> 
> Cristian Chilipirea (1):
>       Bluetooth: Fixed checkpatch warnings
> 
> David Herrmann (5):
>       Bluetooth: Remove redundant hdev->parent field
>       Bluetooth: vhci: Ignore return code of nonseekable_open()
>       Bluetooth: Move hci_alloc/free_dev close to hci_register/unregister_dev
>       Bluetooth: Move device initialization to hci_alloc_dev()
>       Bluetooth: Remove unneeded initialization in hci_alloc_dev()
> 
> Eldad Zack (1):
>       Bluetooth: bnep: use constant for ethertype
> 
> Gustavo Padovan (13):
>       Bluetooth: Remove sk parameter from l2cap_chan_create()
>       Bluetooth: Remove err parameter from alloc_skb()
>       Bluetooth: remove unneeded declaration of sco_conn_del()
>       Bluetooth: Remove unneeded elements from size calculation
>       Bluetooth: Remove hlen variable
>       Bluetooth: notify userspace of security level change
>       Bluetooth: Fix wrong set of skb fragments
>       Bluetooth: Fix packet size provided to the controller
>       Bluetooth: Fix skb length calculation
>       Bluetooth: improve readability of l2cap_seq_list code
>       Bluetooth: report the right security level in getsockopt
>       Bluetooth: Create flags for bt_sk()
>       Bluetooth: Report proper error number in disconnection
> 
> Hemant Gupta (5):
>       Bluetooth: Send correct address type for LTK
>       Bluetooth: Fix clearing discovery type when stopping discovery
>       Bluetooth: mgmt: Fix missing connect failed event for LE
>       Bluetooth: mgmt: Fix address type while loading Long Term Key
>       Bluetooth: Don't distribute keys in case of Encryption Failure
> 
> Ido Yariv (1):
>       Bluetooth: Search global l2cap channels by src/dst addresses
> 
> Jesper Juhl (1):
>       Bluetooth: btmrvl_sdio: remove pointless conditional before release_firmware()
> 
> Johan Hedberg (2):
>       Bluetooth: mgmt: Fix device_connected sending order
>       Bluetooth: Fix Inquiry with RSSI event mask
> 
> Larry Finger (1):
>       rtlwifi: fix for race condition when firmware is cached

????

What did you do here?  I thought that maybe you had pulled from the
wireless tree, but the commit ID is different.

I know that you want this to get merged in time for the window --
but it has to be done right.  Occasionally there might be a reason
for the same patch to end-up in two places, but in this case you have
an rtlwifi patch being replicated in the Bluetooth tree...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
