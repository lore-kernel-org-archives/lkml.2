Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab2CGNvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:51:24 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:46457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab2CGNvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:51:22 -0500
Subject: Re: 3.3.0-rc6-next-20120305 - iwlwifi BUG sleeping function called
 from invalid context (2 similar ones)
From: Johannes Berg <johannes@sipsolutions.net>
To: Valdis.Kletnieks@vt.edu
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <30424.1331126649@turing-police.cc.vt.edu> (sfid-20120307_142549_021050_BEB02510)
References: <30424.1331126649@turing-police.cc.vt.edu>
	 (sfid-20120307_142549_021050_BEB02510)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Mar 2012 14:51:12 +0100
Message-ID: <1331128272.3519.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 08:24 -0500, Valdis.Kletnieks@vt.edu wrote:
> Seen in my dmesg, 3.3.0-rc6-next20120305.  Dell Latitude E6500,
> Intel 5100 wireless card.  Seems to be pretty reproducible.
> 
> Have hit this one 368 times in 10 hours of uptime:
> 
> [  159.765059] wlan0: authenticate with d8:c7:c8:81:98:f0
> [  159.767884] wlan0: send auth to d8:c7:c8:81:98:f0 (try 1/3)
> [  159.769451] wlan0: authenticated
> [  159.769870] wlan0: waiting for beacon from d8:c7:c8:81:98:f0
> [  159.881293] wlan0: associate with d8:c7:c8:81:98:f0 (try 1/3)
> [  159.883470] wlan0: RX AssocResp from d8:c7:c8:81:98:f0 (capab=0x511 status=0 aid=4)
> [  159.883474] wlan0: associated
> [  159.890205] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  164.620017] BUG: sleeping function called from invalid context at drivers/net/wireless/iwlwifi/iwl-trans.h:459

Yeah, thanks for the report -- it's an erroneous might_sleep() in a
function that can't and won't sleep. There's a patch on the way to
remove it.

johannes

