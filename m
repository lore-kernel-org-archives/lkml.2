Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0K2Hnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 02:43:51 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:56649 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754977Ab0K2Hnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 02:43:50 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/7] hid: egalax: Rework to include Joojoo and Wetab support
Date: Mon, 29 Nov 2010 08:43:25 +0100
Message-Id: <1291016612-25102-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PMyOm-0000Sq-AY.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PMyOm-0000Sq-AY 33628bd51b02225521101115244f03d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

This is the second version of this patchset, extended to also support
the Wetab. The input core changes aside, the patches provide exactly
the same changes, except for a better signal-to-noise value provided
by Phillip.

The first patch is already in your tree, but provided for completeness
(the present set is against -rc3). The second patch no longer sets up
the events per packet, since it is handled during slots
initialization. The third and fourth patch are identical, the fifth
has that new value, and the sixth is further simplified by using the
new input core interface. The seventh patch adds support for the
Wetab.

The driver has been tested succesfully on all three supported device
ids.

Cheers,
Henrik

Henrik Rydberg (7):
  hid: egalax: Use kzalloc
  hid: egalax: Setup input device manually (rev2)
  hid: egalax: Correct for device resolution report error (rev2)
  hid: egalax: Report zero as minimum pressure (rev2)
  hid: egalax: Add event filtering (rev3)
  hid: egalax: Convert to MT slots (rev2)
  hid: egalax: Add support for Wetab

 drivers/hid/hid-core.c   |    1 +
 drivers/hid/hid-egalax.c |  129 +++++++++++++++++++---------------------------
 drivers/hid/hid-ids.h    |    1 +
 3 files changed, 56 insertions(+), 75 deletions(-)

