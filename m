Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab1BUXsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:48:37 -0500
Received: from vs1.gondor.com ([78.47.100.202]:45556 "EHLO
	mail.moria.gondor.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750836Ab1BUXsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:48:36 -0500
X-Greylist: delayed 1173 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Feb 2011 18:48:36 EST
Date: Tue, 22 Feb 2011 00:29:02 +0100
From: Jan Niehusmann <jan@gondor.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: TX VLAN acceleration on bridges broken in 2.6.37?
Message-ID: <20110221232902.GA3440@x61s.reliablesolutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the following configuration, sending vlan tagged traffic from a
bridged interface doesn't work in 2.6.37.
The same configuration does work with 2.6.36:

- bridge br0 with physical interface eth0
- eth0 being an e1000e device (don't know if that's important)
- vlan interface br0.10
- (on 2.6.37) tx vlan acceleration active on br0 (default)

Networking on br0.10 doesn't work, and tcpdump on eth0 shows packets
sent on br0.10 as untagged, instead of vlan 10 tagged.

After turning vlan tx offloading off with 'ethtool -K br0 txvlan off',
everything works as expected, again.

The workaround is made permanent by reverting "bridge: Add support for
TX vlan offload.", 361ff8a6cf90d62c0071b7e532e37369bfd3ae77, turning
of the feature on bridges completely.

Jan

