Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab1JaRyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:54:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab1JaRyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:54:32 -0400
Date: Mon, 31 Oct 2011 17:34:22 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Nai Xia <nai.xia@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
Message-ID: <20111031163422.GC3466@redhat.com>
References: <201110122012.33767.pluto@agmk.net>
 <20111021155632.GD4082@suse.de>
 <20111021174120.GJ608@redhat.com>
 <201110221307.11615.nai.xia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110221307.11615.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nai,

On Sat, Oct 22, 2011 at 01:07:11PM +0800, Nai Xia wrote:
> Yeah, anon_vma root lock is a big lock. And JFYI, actually I am doing 
> some very nasty hacking on anon_vma and one of the side effects is 
> breaking the root lock into pieces. But this area is pretty 
> convolved by many racing conditions. I hope some day I will finally make
> my patch work and have your precious review of it. :-)

:) It's going to be not trivial, initially it was not a shared lock
but it wasn't safe that way (especially with migrate required a
reliable rmap_walk) and using a shared lock across all
same_anon_vma/same_vma lists was the only way to be safe and solve the
races.
