Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1JZVPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:15:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36811 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1JZVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:15:04 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Additional ALPS touchpad protocol support
Date: Wed, 26 Oct 2011 16:14:34 -0500
Message-Id: <1319663681-11244-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for two ALPS touchpad protocol versions
currently unsupported by the driver, which I've arbitrarily called
versions 3 and 4 (with the two currently supported protocol versions
changed to be called versions 1 and 2). The v3 touchpads are commonly
found on Dell laptops, and the v4 touchpads are found on machines from a
variety of other manufacturers.

Both the v3 and v4 touchpads are capable of low-resolution semi-MT
support, but this series only includes support for semi-MT on v3. The v4
protocol has a quirky format, with each data packet containing a full
set of high-resolution ST coordinates and 1/3 of a set of MT data. Thus
we receive 3 ST coordinates for every set of MT coordinates, and we can
only determine the number of contacts every third packet as well. I
haven't spent much time trying to work out the best way to handle this
yet; suggestions are appreciated.

Patches 1-4 are preparatory patches. Patch 5 adds ST support for the v3
and v4 protocols, and patch 6 adds semi-MT support for the v3 protocol.
Patch 7 documents both protocols.

These patches have been through numerous rounds of user testing with
various laptop models and are working well at this point.

Special thanks to Andy Skalski, who made my job much easier by doing
much of the grunt work to reverse-engineer the v3 protocol.

Thanks,
Seth


Seth Forshee (7):
      Input: ALPS - Move protocol information to Documentation
      Input: psmouse - Add PSMOUSE_CMD_RESET_WRAP
      Input: ALPS - Add protocol version field in alps_model_info
      Input: ALPS - Remove assumptions about packet size
      Input: ALPS - Add support for protocol versions 3 and 4
      Input: ALPS - Add semi-MT support for v3 protocol
      Input: ALPS - Add documentation for protocol versions 3 and 4

 Documentation/input/alps.txt  |  188 ++++++++
 drivers/input/mouse/alps.c    | 1047 +++++++++++++++++++++++++++++++++++++----
 drivers/input/mouse/alps.h    |   19 +
 drivers/input/mouse/psmouse.h |    1 +
 4 files changed, 1170 insertions(+), 85 deletions(-)
 create mode 100644 Documentation/input/alps.txt
