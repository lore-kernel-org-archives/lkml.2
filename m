Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0JMN7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:59:30 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:49289 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648Ab0JMN72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:59:28 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 0/6] hid: egalax: Rework to include joojoo support
Date: Wed, 13 Oct 2010 15:58:16 +0200
Message-Id: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P61qq-0001oc-Bf.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1P61qq-0001oc-Bf fd24d422426ba46d028670ab21697d94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri, Stephane,

This series adds support for the joojoo tablet. Based on the
jikos/egalax branch, the first two patches prepare for the change to
MT slots. The third patch fixes the bug that was also fixed by commit
f516611, but in another (agreed) way. The fourth patch fixes another
minor problem. The fifth patch adds event filtering based on observed
signal quality, and the sixth patch does the heavy lifting of
converting to MT slots and thereby solving the major problem for the
joojoo.

The patches have been tested on both supported devices. Thanks Philipp!

Henrik

Henrik Rydberg (6):
  hid: egalax: Use kzalloc
  hid: egalax: Setup input device manually
  hid: egalax: Correct for device resolution report error
  hid: egalax: Report zero as minimum pressure
  hid: egalax: Add event filtering
  hid: egalax: Convert to MT slots

 drivers/hid/hid-egalax.c |  177 +++++++++++++++++++++++++++-------------------
 1 files changed, 103 insertions(+), 74 deletions(-)

