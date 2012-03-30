Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965877Ab2C3VT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:19:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965759Ab2C3VTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:37 -0400
Message-Id: <20120330194835.189892312@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg Rose <gregory.v.rose@intel.com>,
        Sibai Li <sibai.li@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 057/175] rtnetlink: Fix VF IFLA policy
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Rose <gregory.v.rose@intel.com>

commit 48752f6513012a1b078da08b145d5c40a644f058 upstream.

Add VF spoof check to IFLA policy.  The original patch I submitted to
add the spoof checking feature to rtnl failed to add the proper policy
rule that identifies the data type and len.  This patch corrects that
oversight.  No bugs have been reported against this but it may cause
some problem for the netlink message parsing that uses the policy
table.

Signed-off-by: Greg Rose <gregory.v.rose@intel.com>
Tested-by: Sibai Li <sibai.li@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/rtnetlink.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1133,6 +1133,8 @@ static const struct nla_policy ifla_vf_p
 				    .len = sizeof(struct ifla_vf_vlan) },
 	[IFLA_VF_TX_RATE]	= { .type = NLA_BINARY,
 				    .len = sizeof(struct ifla_vf_tx_rate) },
+	[IFLA_VF_SPOOFCHK]	= { .type = NLA_BINARY,
+				    .len = sizeof(struct ifla_vf_spoofchk) },
 };
 
 static const struct nla_policy ifla_port_policy[IFLA_PORT_MAX+1] = {


