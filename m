Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab1KCNQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:16:18 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:43004 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183Ab1KCNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:16:17 -0400
Subject: [PATCH] kconfig: accept negative hexadecimals
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 14:16:00 +0100
Message-ID: <1320326160.14409.223.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig will print a warning when confronted with a negative "hex"
value:
	'number is invalid'

Make this warning disappear for valid negative hexadecimals (ie, valid
hexadecimal numbers that start with a minus sign, optionally followed by
"0x").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
I ran into this while trying some possible cleanups to various "hex"
config entries, for which I needed to add a negative default. Currently
there are no "hex" config entries with a negative default. (I don't know
whether this warning can be triggered any other way.)

This also allows to enter negative values for "hex" config entries.
Apparently that's currently not needed. But these will then show up as
(eg) "0x-ff" in the GUI. Should that be fixed in a separate commit or
should I update this patch?

 scripts/kconfig/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 071f00c..2b33478 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -551,6 +551,8 @@ bool sym_string_valid(struct symbol *sym, const char *str)
 		}
 		return true;
 	case S_HEX:
+		if (str[0] == '-')
+			str++;
 		if (str[0] == '0' && (str[1] == 'x' || str[1] == 'X'))
 			str += 2;
 		ch = *str++;
-- 
1.7.4.4

