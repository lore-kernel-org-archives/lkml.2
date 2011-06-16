Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1FPAkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:40:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:43510 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab1FPAkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:40:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Steve Chiang <windtracekimo@gmail.com>
Subject: Question about page count
Date: Thu, 16 Jun 2011 00:34:39 +0000 (UTC)
Message-ID: <loom.20110616T022434-391@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 91.20.195.44 (Mozilla/5.0 (X11; Linux i686; rv:2.0.1) Gecko/20100101 Firefox/4.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
i am currently analyzing the memory pages footprint in 2.6.18.8 kernel (1GB ram,
32-bit, Flat model, no NUMA), and got a question. Does page_count(page)==0
really means the page is free because the source code says so?

If I just traverse mem_map for all memory descriptor, and count how many of them
has page_count 0, then the number of free page will exceed the MemFree number
reported from /proc/meminfo (actually from the zone list).

After some investigation, I figure out that page->flags actually encode the zone
information (DMA, NORMAL, HIGHMEM), and some of the page descriptors do not have
correct zone number. But filtering them out doesn't help.

In my case, HIGHMEM has 61 free pages reported by /proc/meminfo, but when I
traverse the page descriptors array from (896MB - 1024MB), I count the pages with
(1) flags stating its zone == ZONE_HIGHMEM
(2) page_count(page)==0
My result is 186 but not 61.

Could anyone help on explaining this?

Thanks,
Steve

