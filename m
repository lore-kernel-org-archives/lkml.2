Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0DUOQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:16:54 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:56846 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab0DUOQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:16:53 -0400
Date: Wed, 21 Apr 2010 09:15:52 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Tejun Heo <tj@kernel.org>, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
In-Reply-To: <20100420150522.GG19264@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1004210914570.4959@router.home>
References: <4BC6CB30.7030308@kernel.org> <l2u28c262361004150240q8a873b6axb73eaa32fd6e65e6@mail.gmail.com> <4BC6E581.1000604@kernel.org> <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com> <4BC6FBC8.9090204@kernel.org>
 <w2h28c262361004150449qdea5cde9y687c1fce30e665d@mail.gmail.com> <alpine.DEB.2.00.1004161105120.7710@router.home> <1271606079.2100.159.camel@barrios-desktop> <alpine.DEB.2.00.1004191235160.9855@router.home> <4BCCD8BD.1020307@kernel.org>
 <20100420150522.GG19264@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010, Mel Gorman wrote:

> alloc_pages_exact_node() avoids a branch in a hot path that is checking for
> something the caller already knows. That's the reason it exists.

We can avoid alloc_pages_exact_node() by making all callers of
alloc_pages_node() never use -1. -1 is ambiguous and only rarely will a
caller pass that to alloc_pages_node().


