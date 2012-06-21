Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2FUVXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:23:46 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:36452
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760370Ab2FUVXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:23:45 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2012 17:23:45 EDT
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/13] drivers: hv: kvp
Date: Thu, 21 Jun 2012 14:30:00 -0700
Message-Id: <1340314200-27078-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset expands the KVP (Key Value Pair) functionality to
implement the mechanism to get/set IP addresses in the guest. This
functionality is used in Windows Server 2012 to implement VM
replication functionality. The way IP configuration information
is managed is distro specific. The current implementation supports
RedHat way of doing things. We will expand support to other distros
incrementally. 



K. Y. Srinivasan (13):
  Drivers: hv: Add KVP definitions for IP address injection
  Drivers: hv: kvp: Cleanup error handling in KVP
  Drivers: hv: kvp: Support the new IP injection messages
  Tools: hv: Prepare to expand  kvp_get_ip_address() functionality
  Tools: hv: Further refactor kvp_get_ip_address()
  Tools: hv: Gather address family information
  Tools: hv: Gather subnet information
  Tools: hv: Represent the ipv6 mask using CIDR notation
  Tools: hv: Gather DNS information
  Tools: hv: Gather ipv[4,6] gateway information
  Tools: hv: Gather dhcp information
  Tools: hv: Implement the KVP verb - KVP_OP_GET_IP_INFO
  Tools: hv: Implement the KVP verb - KVP_OP_SET_IP_INFO

 drivers/hv/hv_kvp.c      |  103 ++++++--
 include/linux/hyperv.h   |   39 +++-
 tools/hv/hv_kvp_daemon.c |  650 ++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 686 insertions(+), 106 deletions(-)

-- 
1.7.4.1

