Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab0DPQJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:09:09 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:50347 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0DPQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:09:05 -0400
Date: Fri, 16 Apr 2010 11:07:55 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
In-Reply-To: <w2h28c262361004150449qdea5cde9y687c1fce30e665d@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1004161105120.7710@router.home>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>  <4BC65237.5080408@kernel.org>  <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>  <4BC6BE78.1030503@kernel.org>  <h2w28c262361004150100ne936d943u28f76c0f171d3db8@mail.gmail.com>
  <4BC6CB30.7030308@kernel.org>  <l2u28c262361004150240q8a873b6axb73eaa32fd6e65e6@mail.gmail.com>  <4BC6E581.1000604@kernel.org>  <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>  <4BC6FBC8.9090204@kernel.org>
 <w2h28c262361004150449qdea5cde9y687c1fce30e665d@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010, Minchan Kim wrote:

> I don't want to remove alloc_pages for UMA system.

alloc_pages is the same as alloc_pages_any_node so why have it?

> #define alloc_pages alloc_page_sexact_node
>
> What I want to remove is just alloc_pages_node. :)

Why remove it? If you want to get rid of -1 handling then check all the
callsites and make sure that they are not using  -1.

Also could you define a constant for -1? -1 may have various meanings. One
is the local node and the other is any node. The difference is if memory
policies are obeyed or not. Note that alloc_pages follows memory policies
whereas alloc_pages_node does not.

Therefore

alloc_pages() != alloc_pages_node(  , -1)

