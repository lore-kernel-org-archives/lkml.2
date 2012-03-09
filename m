Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab2CIUNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:13:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031212Ab2CITuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:16 -0500
Message-Id: <20120309190209.139436408@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesper Juhl <jj@chaosbits.net>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 85/95] dm ioctl: do not leak argv if target message only contains whitespace
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Juhl <jj@chaosbits.net>

commit 902c6a96a7cb9c50d2a8aed1788efad0a5d8f04c upstream.

If 'argc' is zero we jump to the 'out:' label, but this leaks the
(unused) memory that 'dm_split_args()' allocated for 'argv' if the
string being split consisted entirely of whitespace.  Jump to the
'out_argv:' label instead to free up that memory.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1437,7 +1437,7 @@ static int target_message(struct dm_ioct
 
 	if (!argc) {
 		DMWARN("Empty message received.");
-		goto out;
+		goto out_argv;
 	}
 
 	table = dm_get_live_table(md);


