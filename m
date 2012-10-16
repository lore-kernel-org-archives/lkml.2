Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2JPBK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:10:59 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57517 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2JPBK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:10:58 -0400
MIME-Version: 1.0
Date: Tue, 16 Oct 2012 09:10:56 +0800
Message-ID: <CAGjSPUBxPjMYSoz=XX9Pq-mDV-_72K37gv1R72vFeEasw05iTA@mail.gmail.com>
Subject: usbutils for Mac OS X and Cygwin
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        libusbx-devel <libusbx-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Now usbutils git almost builds successfully out of the box under Mac OS X
and Cygwin (using libusbx). Just wondering if you can accept the minor
fix for Mac OS X and suggest a way to fix cygwin build.

For Cygwin, there is a conflict with Cygwin's w32api package.

DATADIR conflicts with MinGW and cydwin's <objidl.h> in their w32api
package.
http://caca.zoy.org/changeset/3404

typedef enum tag DATADIR	{
        DATADIR_GET=1,
        DATADIR_SET
} DATADIR;

I do not know the proper fix, so I just temporarily change
objidl.h to

typedef enum tag DATADIR	{
        DATADIR_GET=1,
        DATADIR_SET
} DATADIR1;

After that I can build usbutils.

I only need one fix for Mac OS X as Apple's gcc compiler does not like
--as-needed.

mymacmini:usbutils xiaofanc$ git diff
diff --git a/Makefile.am b/Makefile.am
index 4e53e45..e8cb002 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,8 +1,7 @@
 SUBDIRS = \
        usbhid-dump

-AM_LDFLAGS = \
-       -Wl,--as-needed
+AM_LDFLAGS =

 data_DATA =

-- 
Xiaofan
