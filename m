Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1KGUwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:52:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45748 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab1KGUww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:52:52 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] Additional ALPS touchpad protocol support
Date: Mon,  7 Nov 2011 14:52:33 -0600
Message-Id: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor updates to previous patches to address review comments and to
rebase onto ALPS driver changes in 3.2.

Changes since v1:

 - Changed to use stack-allocated buffer instead of kmalloced buffer in
   alps_poll.
 - Rebased onto alps.c changes merged in 3.2 merge window, changing all
   debug and error messages to use psmouse_* print statements.

Seth Forshee (7):
      Input: ALPS - Move protocol information to Documentation
      Input: psmouse - Add PSMOUSE_CMD_RESET_WRAP
      Input: ALPS - Add protocol version field in alps_model_info
      Input: ALPS - Remove assumptions about packet size
      Input: ALPS - Add support for protocol versions 3 and 4
      Input: ALPS - Add semi-MT support for v3 protocol
      Input: ALPS - Add documentation for protocol versions 3 and 4

 Documentation/input/alps.txt  |  188 ++++++++
 drivers/input/mouse/alps.c    | 1036 +++++++++++++++++++++++++++++++++++++----
 drivers/input/mouse/alps.h    |   19 +
 drivers/input/mouse/psmouse.h |    1 +
 4 files changed, 1163 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/input/alps.txt
