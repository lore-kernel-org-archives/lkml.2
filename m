Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0GDBwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 21:52:32 -0400
Received: from wdscspam2.wdc.com ([129.253.170.131]:52267 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0GDBwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 21:52:31 -0400
X-Greylist: delayed 698 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jul 2010 21:52:31 EDT
X-IronPort-AV: E=Sophos;i="4.53,532,1272870000"; 
   d="scan'208";a="117638745"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: EXT3 FS and 64K blocks error
Date: Sat, 3 Jul 2010 18:40:40 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5B24AED0@wdscexbe07.sc.wdc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: EXT3 FS and 64K blocks error
Thread-Index: AcsbGelH/Dcv3mRTQsmpF8v1Oq8SeQ==
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Jul 2010 01:40:40.0247 (UTC) FILETIME=[E8B48C70:01CB1B19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're getting the following error with an EXT3 file sytem that
has 64K blocks (2.6.32.12, on a powerpc), although I don't see
any fixes for later kernels in a diff against 2.6.35-rc3):

ext3_readdir: bad entry in directory #11: rec_len is smaller than minimal -
offset=0, inode=0, rec_len=0, name_len=0

That message is generated in fs/ext3/dir.c:ext3_check_dir_entry()
when called from fs/ext3/dir.c:ext3_readdir(), AFAICT.

Did something get missed when EXT* handling for 64K blocks was
implemented or when a new feature was added?

Dan Taylor
