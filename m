Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2GNURx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:17:53 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:49537
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751460Ab2GNURq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:17:46 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/15] drivers: hv: kvp 
Date: Sat, 14 Jul 2012 13:32:10 -0700
Message-Id: <1342297930-12607-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset expands the KVP (Key Value Pair) functionality to
implement the mechanism to GET/SET IP addresses in the guest. This
functionality is used in Windows Server 2012 to implement VM
replication functionality. The way IP configuration information
is managed is distro specific. Based on the feedback I have gotten
from Olaf, Greg, Steve, Ben and Mairus, I have chosen to seperate
distro specific code from this patch-set. Most of the GET operation
can be implemented in a way that is completely distro independent and
I have implemented that as such and is included in this patch-set.
Some of the attributes that can only be fetched in a distro
dependent way as well the mechanism for configuring an interface
(the SET operation) that is cledarly distro specific is to be
implemented via external scripts that will be invoked via the KVP
code. We define here the interface to these scripts.

K. Y. Srinivasan (15):
  Drivers: hv: Format GUIDS as per MSFT standards
  Drivers: hv: Add KVP definitions for IP address injection
  Drivers: hv: kvp: Cleanup error handling in KVP
  Drivers: hv: kvp: Support the new IP injection messages
  Tools: hv: Prepare to expand  kvp_get_ip_address() functionality
  Tools: hv: Further refactor kvp_get_ip_address()
  Tools: hv: Gather address family information
  Tools: hv: Gather subnet information
  Tools: hv: Represent the ipv6 mask using CIDR notation
  Tools: hv: Gather ipv[4,6] gateway information
  Tools: hv: Gather DNS information
  Tools: hv: Gather DHCP information
  Tools: hv: Implement the KVP verb - KVP_OP_SET_IP_INFO
  Tools: hv: Rename the function kvp_get_ip_address()
  Tools: hv: Implement the KVP verb - KVP_OP_GET_IP_INFO

 drivers/hv/hv_kvp.c      |  172 +++++++++--
 drivers/hv/hv_util.c     |    4 +-
 drivers/hv/vmbus_drv.c   |    4 +-
 include/linux/hyperv.h   |   45 +++-
 tools/hv/hv_kvp_daemon.c |  804 +++++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 914 insertions(+), 115 deletions(-)

-- 
1.7.4.1

