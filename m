Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345Ab1JFWEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:04:04 -0400
Received: from smtp209.alice.it ([82.57.200.105]:51290 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965305Ab1JFWD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:03:59 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Johannes Berg <johannes.berg@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] leds: some issues with hardware blinking
Date: Fri,  7 Oct 2011 00:03:29 +0200
Message-Id: <1317938611-4418-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.6.3
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

having software fall-back for blinking when hardware blinking does not
work or is not available is really good, however there are some cases
which are not covered in the current implementation. See the two
following patches.

The first one is needed to make the "timer" trigger work at all when
hardware blinking is available.

The second one is more like an RFC, since I am not sure I like the way I
fixed it, but the issue is there: mixing hardware and software blinking
can leave the timer on when not needed.

Thanks,
   Antonio

Antonio Ospite (2):
  leds: save the delay values after a successful call to blink_set()
  leds: turn the blink_timer off before starting to blink

 drivers/leds/led-class.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

--
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
-- 
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
