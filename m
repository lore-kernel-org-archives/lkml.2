Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1DLOvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:51:53 -0400
Received: from kroah.org ([198.145.64.141]:57592 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283Ab1DLOiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:53 2011
Message-Id: <20110412143552.968070130@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: [047/105] HID: hid-magicmouse: Increase evdev buffer size
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chase Douglas <chase.douglas@canonical.com>

commit cc5e0f08ca2a66fc4c6984ccff74fd529e969fac upstream.

The evdev buffer isn't big enough when you get many fingers on the
device. Bump up the buffer to a reasonable size, matching what other
multitouch devices use. Without this change, events may be discarded in
the evdev buffer before they are read.

Reported-by: Simon Budig <simon@budig.de>
Cc: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Acked-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-magicmouse.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -418,6 +418,8 @@ static void magicmouse_setup_input(struc
 			input_set_abs_params(input, ABS_MT_POSITION_Y, -2456,
 				2565, 4, 0);
 		}
+
+		input_set_events_per_packet(input, 60);
 	}
 
 	if (report_undeciphered) {


