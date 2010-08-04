Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab0HDOG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:06:59 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40740 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab0HDOG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:06:58 -0400
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com, andi@firstfloor.org,
        david@fromorbit.com
In-Reply-To: <87fx609i29.fsf@gmail.com>
References: <87fx609i29.fsf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 17:04:42 +0300
Message-ID: <1280930682.15689.71.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Aug 2010 14:05:53.0702 (UTC) FILETIME=[26CE9460:01CB33DE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 20:51 -0800, Don Mullis wrote:
> The use of list_sort() by UBIFS looks like it could generate long
> lists; this alternative implementation scales better, reaching ~3x
> performance gain as list length approaches the L2 cache size.
> 
> Stand-alone program timings were run on a Core 2 duo L1=32KB L2=4MB,
> gcc-4.4, with flags extracted from an Ubuntu kernel build.  Object
> size is 552 bytes versus 405 for Mark J. Roberts' code.
> 
> Worst case for either implementation is a list length just over a POT,
> and to roughly the same degree, so here are results for a range of
> 2^N+1 lengths.  List elements were 16 bytes each including malloc
> overhead; random initial order.

This patch breaks UBIFS. I did not have time to dig deeper, but the
symptoms is that list_sort() calls the 'cmp()' function with bogus
'struct list_head *a' parameter, which did not exist in the original
list.

I see this on 2.6.35-rc1. Did not try the release yet. But when I revert
your patch - everything works fine.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

