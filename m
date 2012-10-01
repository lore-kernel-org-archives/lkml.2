Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab2JAPYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:24:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34239 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2JAPYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:24:24 -0400
Date: Mon, 1 Oct 2012 08:23:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jamie Gloudon <jamie.gloudon@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: x86_64: wrong DirectMap kB
In-Reply-To: <20121001104652.GA1390@darkstar>
Message-ID: <alpine.LSU.2.00.1210010812530.1914@eggly.anvils>
References: <20121001104652.GA1390@darkstar>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012, Jamie Gloudon wrote:
> 
>  Interesting. I am able to reproduce the same problem as you using mem=700M, which shows: 
> 
> DirectMap4k:        4096 kB
> DirectMap2M:    18446744073709547520 kB
> 
> However, it appears to be normal without the boot parameter:
> 
> DirectMap4k:        4096 kB
> DirectMap2M:    15708160 kB

It appears to be normal because the calculations haven't wrapped around,
but if you compare with 3.4 or before, I think you'll find that it
still adds up to too little.

> 
> What does your output looks like with the full amount on 3.6?

On 3.6:

MemTotal:        8060528 kB
...
DirectMap4k:        2048 kB
DirectMap2M:     7229440 kB

So it's showing significantly less direct mapped than is included
in MemTotal (which itself omits some areas of reserved memory).

Whereas on 3.4:

MemTotal:        8060760 kB
...
DirectMap4k:        4096 kB
DirectMap2M:     8275968 kB

Hugh
