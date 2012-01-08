Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2AHVXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 16:23:23 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17073 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2AHVXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 16:23:22 -0500
Date: Sun, 8 Jan 2012 22:23:16 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: e1000-devel Mailing List <e1000-devel@lists.sourceforge.net>
cc: "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>, linux-kernel@vger.kernel.org
Subject: Intel ixgbe: uninitialized variable use in ixgbe_non_sfp_link_config()
Message-ID: <alpine.LNX.2.00.1201082221550.24030@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi (sorry about the duplicate, I messed up the LKML addr. on the first mail)

In ixgbe_non_sfp_link_config(), the variable 'negotiation' is declared
without initializer and unless we take the true branch in the 'if
((!autoneg) && (hw->mac.ops.get_link_capabilities))' statement it will
remain uninitialized when it is subsequently read in the 'ret =
hw->mac.ops.setup_link(hw, autoneg, negotiation, link_up)' statement.

The test of 'ret' after the 'if ((!autoneg) &&
(hw->mac.ops.get_link_capabilities))' statement also looks fairly
pointless if we do not take the true branch, since then 'ret' will not
have been changed since the previous identical test.

The correct fix escapes me since I don't really know this code (and don't 
plan to spend the time to get to know it), but I thought I'd just report 
what I had noticed and then someone else can hopefully come up with a good 
fix :-)


PS. Please CC me on replies.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

