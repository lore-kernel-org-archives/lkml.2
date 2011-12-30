Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1L3Rpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 12:45:41 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45408 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1L3Rpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 12:45:39 -0500
MIME-Version: 1.0
In-Reply-To: <4EFD6F22.5010501@monstr.eu>
References: <4EEF42F5.7040002@monstr.eu>
	<20111219162835.GA24519@google.com>
	<4EF05316.5050803@monstr.eu>
	<20111229155836.GB3516@google.com>
	<4EFC995A.5090904@monstr.eu>
	<20111229170745.GE3516@google.com>
	<4EFD6F22.5010501@monstr.eu>
Date: Sat, 31 Dec 2011 02:45:37 +0900
X-Google-Sender-Auth: qCRdpxeGIsp9D81xLJWrj7ADu4s
Message-ID: <CAOS58YPtNRK3mhAp26585+nWFL44kghfAh8vfiB=kdEYmn_8bg@mail.gmail.com>
Subject: Re: memblock and bootmem problems if start + size = 4GB
From: Tejun Heo <tj@kernel.org>
To: monstr@monstr.eu
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sam Ravnborg <sam@ravnborg.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 30, 2011 at 4:58 PM, Michal Simek <monstr@monstr.eu> wrote:
> I haven't said to replace phys_addr_t!
> My point was something like this (just as example on parisc and
> free_bootmem_node).
> The problematic part is kmemleak code which could be good reason not to
> change it.

I think it's still a bad idea and you haven't provided any
justification for it.  Think about it - any user which uses pa() may
get that last page and if that user is using [start,end) range, it may
overflow.  It doesn't even matter how you implement it.  I just can't
understand why you obsess about that last page.  It doesn't matter.
Just add those few lines to exclude the last single page and be done
with it.  Unless you're gonna provide rationale for why adding such
risk and more complexity makes sense for that single last page which
most BIOSes wouldn't even map, I don't really think this thread is
going anywhere.

Thanks.

-- 
tejun
