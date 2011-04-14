Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab1DNRq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:38396 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306Ab1DNRq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 083/209] USB: ftdi_sio: revert "USB: ftdi_sio: fix DTR/RTS line modes"
Date: Thu, 14 Apr 2011 13:41:53 -0400
Message-Id: <1302803039-9400-84-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 677aeafe19e88c282af74564048243ccabb1c590 upstream.

This reverts commit 6a1a82df91fa0eb1cc76069a9efe5714d087eccd.

RTS and DTR should not be modified based on CRTSCTS when calling
set_termios.

Modem control lines are raised at port open by the tty layer and should stay
raised regardless of whether hardware flow control is enabled or not.

This is in conformance with the way serial ports work today and many
applications depend on this behaviour to be able to talk to hardware
implementing hardware flow control (without the applications actually using
it).

Hardware which expects different behaviour on these lines can always
use TIOCMSET/TIOCMBI[SC] after port open to change them.

Reported-by: Daniel Mack <daniel@caiaq.de>
Reported-by: Dave Mielke <dave@mielke.cc>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 6c7b6ba..a654281 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2348,8 +2348,6 @@ static void ftdi_set_termios(struct tty_struct *tty,
 				"urb failed to set to rts/cts flow control\n");
 		}
 
-		/* raise DTR/RTS */
-		set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	} else {
 		/*
 		 * Xon/Xoff code
@@ -2397,8 +2395,6 @@ static void ftdi_set_termios(struct tty_struct *tty,
 			}
 		}
 
-		/* lower DTR/RTS */
-		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	}
 	return;
 }
-- 
1.7.4.4

