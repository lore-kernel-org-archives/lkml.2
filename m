Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2J2P06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:26:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43146 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2J2P0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:26:55 -0400
MIME-Version: 1.0
Message-ID: <1b8baea8-531a-45a0-b490-4a2ac5c64784@default>
Date: Mon, 29 Oct 2012 08:25:07 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, gaowanlong@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: RE: [PATCH v3 0/3] zram/zsmalloc promotion
References: <<1351501009-15111-1-git-send-email-minchan@kernel.org>>
In-Reply-To: <<1351501009-15111-1-git-send-email-minchan@kernel.org>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> Subject: [PATCH v3 0/3] zram/zsmalloc promotion
> 
> The candidate is two under mm/ or under lib/
> Konrad and Nitin wanted to put zsmalloc into lib/ instead of mm/.
> 
> Quote from Nitin
> "
> I think mm/ directory should only contain the code which is intended
> for global use such as the slab allocator, page reclaim code etc.
> zsmalloc is used by only one (or possibly two) drivers, so lib/ seems
> to be the right place.
> "
> 
> Quote from Konrand
> "
> I like the idea of keeping it in /lib or /mm. Actually 'lib' sounds more
> appropriate since it is dealing with storing a bunch of pages in a nice
> layout for great density purposes.
> "
> 
> In fact, there is some history about that.
> 
> Why I put zsmalloc into under mm firstly was that Andrew had a concern
> about using strut page's some fields freely in zsmalloc so he wanted
> to maintain it in mm/ if I remember correctly.
> 
> So I and Nitin tried to ask the opinion to akpm several times
> (at least 6 and even I sent such patch a few month ago) but didn't get
> any reply from him so I guess he doesn't have any concern about that
> any more.
> 
> In point of view that it's an another slab-like allocator,
> it might be proper under mm but it's not popular as current mm's
> allocators(/SLUB/SLOB and page allocator).
> 
> Frankly speaking, I don't care whether we put it to mm/ or lib/.
> It seems contributors(ex, Nitin and Konrad) like lib/ and Andrew is still
> silent. That's why I am biased into lib/ now.
> 
> If someone yell we should keep it to mm/ by logical claim, I can change
> my mind easily. Please raise your hand.
> 
> If Andrew doesn't have a concern about that any more, I would like to
> locate it into /lib.

FWIW, I would vote for /lib as well.

Dan
