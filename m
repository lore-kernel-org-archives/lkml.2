Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1FIHDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:03:03 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63750 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab1FIHDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:03:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OMTIX42G8I+fvKumHxmZbKBT5s+T457ung4UtvE1GdeCTqKpv8ibOx0LsP/G2DMkmj
         U9TpdFlwlkD8ATqW0xgYSBdR/Wlhx1xhBQukP1rfHjKS3C9dsyZoHS6bWtAMdYcApNfy
         7TaPbrYFpH0sWmbTzkpNMsdTgpg3JSovyeIUM=
From: Weiping Pan <panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weiping Pan <panweiping3@gmail.com>
Subject: [PATCH v4 net-next 0/5] bonding:use latest lacp_rate and ad_select,
Date: Thu,  9 Jun 2011 15:03:26 +0800
Message-Id: <cover.1307601948.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is bug that when you modify lacp_rate via sysfs,
802.3ad won't use the new value of lacp_rate to transmit packets.
This is because port->actor_oper_port_state isn't changed.

As for ad_select, it can work,
but both struct bond_params and ad_bond_info have lacp_fast and ad_select,
they are duplicate and need extra synchronization.
802.3ad can get them from bond_params directly every time.

And ad_timer and arp_mon_pt aren't used any more, just delete them.

changelog:
v2:
add bond_3ad_update_lacp_rate() as a helper function,
and hold bond->lock when iterates slave list.

v3:
delete duplicate lacp_fast and agg_select_mode from struct ad_bond_info.

v4:
delete unused ad_timer and arp_mon_pt.

Weiping Pan (5):
  bonding: make 802.3ad use latest lacp_rate
  bonding:delete lacp_fast from ad_bond_info
  bonding:delete agg_select_mode from ad_bond_info
  bonding: delete unused ad_timer
  bonding: delete unused arp_mon_pt

 drivers/net/bonding/bond_3ad.c   |   41 ++++++++++++++++++++++++++++++++-----
 drivers/net/bonding/bond_3ad.h   |    8 +-----
 drivers/net/bonding/bond_main.c  |    3 +-
 drivers/net/bonding/bond_sysfs.c |    1 +
 drivers/net/bonding/bonding.h    |    1 -
 5 files changed, 39 insertions(+), 15 deletions(-)

-- 
1.7.4.4

