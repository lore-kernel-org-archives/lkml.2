Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0DVKPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:15:21 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:44766 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0DVKPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AP0NWNoRjOLxg4LbZr9IdimrHeXCE/EdRPo0M+HP8yggxjbu/KvEk1C5/x5v191A9l
         elmN88Zy+nVkDKWFYyM4vss/gMlGufOmK7Z+gsBi7zgWbH2ldYSeT4FPTYSgADcl0z3U
         OXUwRJaBFafrZ2t1hcLlMVhF6SmMj/uW5A/cc=
MIME-Version: 1.0
In-Reply-To: <4BCED815.90704@kernel.org>
References: <4BC6CB30.7030308@kernel.org>
	 <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>
	 <4BC6FBC8.9090204@kernel.org>
	 <w2h28c262361004150449qdea5cde9y687c1fce30e665d@mail.gmail.com>
	 <alpine.DEB.2.00.1004161105120.7710@router.home>
	 <1271606079.2100.159.camel@barrios-desktop>
	 <alpine.DEB.2.00.1004191235160.9855@router.home>
	 <4BCCD8BD.1020307@kernel.org> <20100420150522.GG19264@csn.ul.ie>
	 <4BCED815.90704@kernel.org>
Date: Thu, 22 Apr 2010 19:15:14 +0900
Message-ID: <x2h28c262361004220315v9b8fbf3ei86fe0ebba92169f1@mail.gmail.com>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 7:48 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 04/20/2010 05:05 PM, Mel Gorman wrote:
>> alloc_pages_exact_node() avoids a branch in a hot path that is checking for
>> something the caller already knows. That's the reason it exists.
>
> Yeah sure but Minchan is trying to tidy up the API by converting
> alloc_pages_node() users to use alloc_pages_exact_node(), at which
> point, the distinction becomes pretty useless.  Wouldn't just making
> alloc_pages_node() do what alloc_pages_exact_node() does now and
> converting all its users be simpler?  IIRC, the currently planned
> transformation looks like the following.
>
>  alloc_pages()                  -> alloc_pages_any_node()
>  alloc_pages_node()             -> basically gonna be obsoleted by _exact_node
>  alloc_pages_exact_node()       -> gonna be used by most NUMA aware allocs
>
> So, let's just make sure no one calls alloc_pages_node() w/ -1 nid,
> kill alloc_pages_node() and rename alloc_pages_exact_node() to
> alloc_pages_node().

Yes. It was a stupid idea. I hope Mel agree this suggestion.
Thanks for careful review, Tejun.


-- 
Kind regards,
Minchan Kim
