Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab1GKPHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:07:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51364 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab1GKPHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:07:02 -0400
Date: Mon, 11 Jul 2011 12:07:01 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2011-07-11
Message-ID: <20110711150700.GC2816@joana>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

This is probably my last pull request to 3.1. Here Andre Guedes adds support to
enable/disable LE in a controller. Joe Perches did a clean great clean up in
our log system. Mat Martineau reworked that Local Busy condition for the
Enhanced Retransmission Mode in L2CAP. And Vinicius Gomes improved the
Security Manager Protocol support, adding suppor to the phase 3 of its pairing
process and support to communicate keys with the userspace. The rest are just
fixes and clean up. Please pull. Thanks!

	Gustavo


The folowing changes since commit 8ae2e12f1534e647d4a816755e5a09c2de6f9fca:

  ath9k_htc: Inform stack about tx ack status (2011-07-08 11:47:57 -0400)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Andre Guedes (7):
      Bluetooth: Add extfeatures to struct hci_dev
      Bluetooth: Write LE Host Supported command
      Bluetooth: Add enable_le module parameter
      Bluetooth: Add lmp_host_le_capable() macro
      Bluetooth: Remove enable_smp parameter
      Bluetooth: Fix potential deadlock in hci_core
      Bluetooth: Fix potential deadlock in mgmt

Gustavo F. Padovan (2):
      Bluetooth: Fix bad locking balance
      Bluetooth: Clean up unused struct hci_conn items

Ilia Kolomisnky (1):
      Bluetooth: Fixes l2cap "command reject" reply according to spec

Joe Perches (2):
      Bluetooth: Rename function bt_err to bt_to_errno
      Bluetooth: Add bt_printk

Mat Martineau (6):
      Bluetooth: Fix indentation whitespace
      Bluetooth: ERTM timeouts need to be converted to jiffies
      Bluetooth: Check earlier for L2CAP ERTM frames to drop
      Bluetooth: Move code for ERTM local busy state to separate functions
      Bluetooth: Use event-driven approach for handling ERTM receive buffer
      Bluetooth: Remove L2CAP busy queue
                                                                                        
Randy Dunlap (1):                                                                       
      Bluetooth: uses crypto interfaces, select CRYPTO                                  
                                                                                        
Steven.Li (1):                                                                          
      Bluetooth: Add Atheros AR3012 one PID/VID supported                               
                                                                                        
Vinicius Costa Gomes (12):                                                              
      Bluetooth: Add support for SMP phase 3 (key distribution)                         
      Bluetooth: Add new structures for supporting SM key distribution                  
      Bluetooth: Add functions to manipulate the link key list for SMP                  
      Bluetooth: Reject an encryption request when the key isn't found                  
      Bluetooth: Fix SM pairing parameters negotiation                                  
      Bluetooth: Add support for storing the LTK                                        
      Bluetooth: Use the link key list to temporarily store the STK                     
      Bluetooth: Use the stored LTK for restabilishing security                         
      Bluetooth: Remove unused field in hci_conn                                        
      Bluetooth: Add support for communicating keys with userspace                      
      Bluetooth: Add support for storing the key size                                   
      Bluetooth: Add support for returning the encryption key size                      
                                                                                        
 drivers/bluetooth/ath3k.c         |    5 +                                             
 drivers/bluetooth/btusb.c         |   12 ++-                                           
 include/net/bluetooth/bluetooth.h |   12 ++-                                           
 include/net/bluetooth/hci.h       |   18 +++                                           
 include/net/bluetooth/hci_core.h  |   29 +++++-                                        
 include/net/bluetooth/l2cap.h     |   25 ++++-                                         
 include/net/bluetooth/mgmt.h      |    2 +
 include/net/bluetooth/smp.h       |    1 +
 net/bluetooth/Kconfig             |    1 +
 net/bluetooth/hci_core.c          |  101 ++++++++++++++----
 net/bluetooth/hci_event.c         |   87 +++++++++++++++-
 net/bluetooth/l2cap_core.c        |  216 ++++++++++++-------------------------
 net/bluetooth/l2cap_sock.c        |   69 +++++++++++-
 net/bluetooth/lib.c               |   23 ++++-
 net/bluetooth/mgmt.c              |  148 +++++++++++++++----------
 net/bluetooth/sco.c               |    4 +-
 net/bluetooth/smp.c               |  208 ++++++++++++++++++++++++++++++++----
 17 files changed, 691 insertions(+), 270 deletions(-)

