Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0DOHS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:18:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:33542 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab0DOHS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:18:27 -0400
Message-ID: <4BC6BE78.1030503@kernel.org>
Date: Thu, 15 Apr 2010 16:21:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>	 <d5d70d4b57376bc89f178834cf0e424eaa681ab4.1271171877.git.minchan.kim@gmail.com>	 <20100413154820.GC25756@csn.ul.ie> <4BC65237.5080408@kernel.org> <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>
In-Reply-To: <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:17:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/15/2010 10:31 AM, Minchan Kim wrote:
> Hi, Tejun.
>> This being a pretty cold path, I don't really see much benefit in
>> converting it to alloc_pages_node_exact().  It ain't gonna make any
>> difference.  I'd rather stay with the safer / boring one unless
>> there's a pressing reason to convert.
> 
> Actually, It's to weed out not-good API usage as well as some
> performance gain.  But I don't think to need it strongly.
> Okay. Please keep in mind about this and correct it if you confirms
> it in future. :)

Hmm... if most users are converting over to alloc_pages_node_exact(),
I think it would be better to convert percpu too.  I thought it was a
performance optimization (of rather silly kind too).  So, this is to
weed out -1 node id usage?  Wouldn't it be better to update
alloc_pages_node() such that it whines once per each caller if it's
called with -1 node id and after updating most users convert the
warning into WARN_ON_ONCE()?  Having two variants for this seems
rather extreme to me.

Thanks.

-- 
tejun
