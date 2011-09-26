Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1IZJU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:20:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46899 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1IZJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:20:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Sep 2011 18:20:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vmscan.c: Invalid strict_strtoul check in
 write_scan_unevictable_node
Message-Id: <20110926182011.dc621e9c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1316948380-1879-1-git-send-email-consul.kautuk@gmail.com>
References: <1316948380-1879-1-git-send-email-consul.kautuk@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Sep 2011 16:29:40 +0530
Kautuk Consul <consul.kautuk@gmail.com> wrote:

> write_scan_unavictable_node checks the value req returned by
> strict_strtoul and returns 1 if req is 0.
> 
> However, when strict_strtoul returns 0, it means successful conversion
> of buf to unsigned long.
> 
> Due to this, the function was not proceeding to scan the zones for
> unevictable pages even though we write a valid value to the 
> scan_unevictable_pages sys file.
> 
> Changing this if check slightly to check for invalid value 
> in buf as well as 0 value stored in res after successful conversion
> via strict_strtoul.
> In both cases, we do not perform the scanning of this node's zones.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



