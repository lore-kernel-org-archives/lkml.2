Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab0EMVfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:35:44 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:48598 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab0EMVfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:35:39 -0400
Message-ID: <4BEC704C.9000709@nortel.com>
Date: Thu, 13 May 2010 15:34:04 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: /proc/<pid>/maps question....why aren't adjacent memory chunks merged?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2010 21:35:35.0991 (UTC) FILETIME=[3937E470:01CAF2E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got a system running a somewhat-modified 2.6.27 on 64-bit x86.

While investigating a userspace memory leak issue I noticed that
/proc/<pid>/maps showed a bunch of adjacent anonymous memory chunks with
identical permissions:

7fd048000000-7fd04c000000 rw-p 00000000 00:00 0
7fd04c000000-7fd050000000 rw-p 00000000 00:00 0
7fd050000000-7fd054000000 rw-p 00000000 00:00 0
7fd054000000-7fd058000000 rw-p 00000000 00:00 0
7fd058000000-7fd05c000000 rw-p 00000000 00:00 0
7fd05c000000-7fd060000000 rw-p 00000000 00:00 0
7fd060000000-7fd064000000 rw-p 00000000 00:00 0
7fd064000000-7fd068000000 rw-p 00000000 00:00 0
7fd068000000-7fd06c000000 rw-p 00000000 00:00 0
7fd06c000000-7fd070000000 rw-p 00000000 00:00 0
7fd070000000-7fd074000000 rw-p 00000000 00:00 0
7fd074000000-7fd078000000 rw-p 00000000 00:00 0
7fd078000000-7fd07c000000 rw-p 00000000 00:00 0
7fd07c000000-7fd07fffe000 rw-p 00000000 00:00 0

I was under the impression that the kernel would merge areas together in
this circumstance.  Does anyone have an idea about what's going on here?

Thanks,

Chris
