Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965842Ab2C3VTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:19:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46401 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965765Ab2C3VTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:17 -0400
Message-Id: <20120330194833.995913606@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 051/175] ntp: Fix integer overflow when setting time
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

commit a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33 upstream.

'long secs' is passed as divisor to div_s64, which accepts a 32bit
divisor. On 64bit machines that value is trimmed back from 8 bytes
back to 4, causing a divide by zero when the number is bigger than
(1 << 32) - 1 and all 32 lower bits are 0.

Use div64_long() instead.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: johnstul@us.ibm.com
Link: http://lkml.kernel.org/r/1331829374-31543-2-git-send-email-levinsasha928@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -275,7 +275,7 @@ static inline s64 ntp_update_offset_fll(
 
 	time_status |= STA_MODE;
 
-	return div_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
+	return div64_long(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
 
 static void ntp_update_offset(long offset)


