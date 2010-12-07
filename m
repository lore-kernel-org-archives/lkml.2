Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0LGCCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:02:47 -0500
Received: from cerberus.infoblox.com ([128.242.99.209]:56176 "EHLO
	cerberus.infoblox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0LGCCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:02:46 -0500
X-Greylist: delayed 2026 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 21:02:46 EST
Message-ID: <4CFD8DD9.1000101@infoblox.com>
Date: Mon, 6 Dec 2010 17:28:57 -0800
From: Kin Cho <kcho@infoblox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: [x86_64] "bad pmd" when using huge pages
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With a stock 2.6.32-8 kernel (with minor patches) configured for
x86_64 and using huge pages, I'm seeing dmesg output like this:

mm/memory.c:144: bad pmd ffff880117bb6128(00000002cca000e7).

At this point one huge page is apparently "leaked" --
h->free_huge_pages in gather_surplus_pages is 1 less, until rebooted.

When this happens, the system is moderately loaded (~70% idle).

Also, if processes (bdb) holding shared (huge) pages are not
restarted, or when configured for x86, the problem doesn't appear.

Looking at the pmd flags, the problem appears to be related to the
_PAGE_PSE bit incorrectly getting set.

Any suggestions/comments is appreciated.

Thanks,

-kin

