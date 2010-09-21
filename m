Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0IUBK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:10:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52662 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0IUBK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:10:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Sep 2010 10:05:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: robm@fastmail.fm, linux-kernel@vger.kernel.org,
        "Bron Gondwana" <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad for
 file/email/web servers
Message-Id: <20100921100522.be252b3d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100916184240.3BC9.A69D9226@jp.fujitsu.com>
References: <1284349152.15254.1394658481@webmail.messagingengine.com>
	<20100916184240.3BC9.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 19:01:32 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Yes, sadly intel motherboard turn on zone_reclaim_mode by default. and
> current zone_reclaim_mode doesn't fit file/web server usecase ;-)
> 
> So, I've created new proof concept patch. This doesn't disable zone_reclaim
> at all. Instead, distinguish for file cache and for anon allocation and
> only file cache doesn't use zone-reclaim.
> 
> That said, high-end hpc user often turn on cpuset.memory_spread_page and
> they avoid this issue. But, why don't we consider avoid it by default?
> 
> 
> Rob, I wonder if following patch help you. Could you please try it?
> 
> 
> Subject: [RFC] vmscan: file cache doesn't use zone_reclaim by default
> 

Hm, can't we use migration of file caches rather than pageout in
zone_reclaim_mode ? Doent' it fix anything ?

Thanks,
-Kame

