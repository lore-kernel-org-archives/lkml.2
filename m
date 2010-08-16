Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab0HPQ24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:28:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50928 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab0HPQ2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:28:54 -0400
Date: Mon, 16 Aug 2010 18:28:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 15/16] drivers/platform/x86: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161828350.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

An error code is stored in the variable error, but it is the variable
result that is returned instead.  So store the error code in result.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics and has not been tested.  In each case, error is
also assigned to the result of a function call.  Perhpas that should be
changed to result as well, and error should be eliminated.

 drivers/platform/x86/fujitsu-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index f44cd26..e7d2259 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -668,7 +668,7 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 
 	fujitsu->input = input = input_allocate_device();
 	if (!input) {
-		error = -ENOMEM;
+		result = -ENOMEM;
 		goto err_stop;
 	}
 
@@ -833,7 +833,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 
 	fujitsu_hotkey->input = input = input_allocate_device();
 	if (!input) {
-		error = -ENOMEM;
+		result = -ENOMEM;
 		goto err_free_fifo;
 	}
 
