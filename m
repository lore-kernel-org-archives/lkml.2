Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab0LNVV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:21:28 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59809 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000Ab0LNVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:21:26 -0500
From: Chase Douglas <chase.douglas@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
Date: Tue, 14 Dec 2010 13:21:08 -0800
Message-Id: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I was left somewhat dissatisfied by the MT_TOOL_ENVELOPE addition, so I decided
to try to propose a different solution for the problem. As a recap, the problem
can best be defined by Synaptics hardware that provide two touch coordinates
(X1, Y1) and (X2, Y2). Unfortunately, the real touches may be at (X1, Y2) and
(X2, Y1). Further, three touches may be recognized, but only two coordinates are
reported.

Following this are four patches. The first merely reverts the MT_TOOL_ENVELOPE
addition. The second adds documentation for evdev codes to the Documentation
directory. It was hastily created, so it has some ommissions and may have some
mistakes. My hope is that we keep this or a similar document up to date whenever
non-obvious codes are added to evdev. The third patch adds the following EV_ABS
codes:

ABS_RECT_MIN_X
ABS_RECT_MIN_Y
ABS_RECT_MAX_X
ABS_RECT_MAX_Y

The purpose of these codes is to provide for devices that at best report a
rectangular bounding box of touches. Instead of using the MT evdev protocol,
this approach uses ST protocol semantics.

Finally, the last patch adds support for the above codes to the synaptics
driver.

It is my belief that this is a better interface than MT_TOOL_ENVELOPE for the
following reasons:

* The code meanings are more readily graspable from the names
* The codes behave with ST semantics, which is useful because we likely cannot
  split properties like pressure and orientation among the touches
* ST semantics are easier to comprehend than MT semantics, and MT isn't required
  to solve this problem
* The codes provide only the max and min values, none in between. This is in
  contrast with MT_TOOL_ENVELOPE, which provides all touches as presented by the
  hardware. However, we don't trust all the coordinate pairings, so providing
  faulty pairings may induce incorrect userspace usage of the events.
* A clear distinction is made here that full multitouch devices should use the
  MT protocol, while lesser devices should use the ST protocol.

Thanks!

-- Chase
