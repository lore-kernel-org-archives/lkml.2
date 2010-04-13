Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0DMQBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:01:33 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:65024 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0DMQBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N7UeVLQl15OEmCO+AA0bITIfVPBSIyjcORBBAiGRTgnsPVNH/TILDoJk2iP0a83ZZ3
         I+w2+P3Mtxjc+GbqEgilnVeC9ViJU2OwmaKv4xVuzuawuLN1CHYmoavA+5uEJIMKqIgj
         7QslpVvR75i3Ta37Let4Ozr0pSpkyKtP1is7U=
MIME-Version: 1.0
In-Reply-To: <20100413155253.GD25756@csn.ul.ie>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <8b348d9cc1ea4960488b193b7e8378876918c0d4.1271171877.git.minchan.kim@gmail.com>
	 <20100413155253.GD25756@csn.ul.ie>
Date: Wed, 14 Apr 2010 01:01:31 +0900
Message-ID: <i2x28c262361004130901p9c34b49cu9c7ebd1a24de5ed9@mail.gmail.com>
Subject: Re: [PATCH 3/6] change alloc function in alloc_slab_page
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 12:52 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Wed, Apr 14, 2010 at 12:25:00AM +0900, Minchan Kim wrote:
>> alloc_slab_page never calls alloc_pages_node with -1.
>
> Are you certain? What about
>
> __kmalloc
>  -> slab_alloc (passed -1 as a node from __kmalloc)
>    -> __slab_alloc
>      -> new_slab
>        -> allocate_slab
>          -> alloc_slab_page
>

Sorry for writing confusing changelog.

I means if node == -1 alloc_slab_page always calls alloc_pages.
So we don't need redundant check.

-- 
Kind regards,
Minchan Kim
