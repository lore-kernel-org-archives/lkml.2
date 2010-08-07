Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0HGHw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:52:57 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49340 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0HGHwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:52:55 -0400
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com, andi@firstfloor.org,
        david@fromorbit.com
In-Reply-To: <1280930682.15689.71.camel@localhost>
References: <87fx609i29.fsf@gmail.com> <1280930682.15689.71.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 10:50:36 +0300
Message-ID: <1281167436.7760.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 Aug 2010 07:52:19.0562 (UTC) FILETIME=[762D7CA0:01CB3605]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 17:04 +0300, Artem Bityutskiy wrote:
> On Wed, 2010-01-20 at 20:51 -0800, Don Mullis wrote:
> > The use of list_sort() by UBIFS looks like it could generate long
> > lists; this alternative implementation scales better, reaching ~3x
> > performance gain as list length approaches the L2 cache size.
> > 
> > Stand-alone program timings were run on a Core 2 duo L1=32KB L2=4MB,
> > gcc-4.4, with flags extracted from an Ubuntu kernel build.  Object
> > size is 552 bytes versus 405 for Mark J. Roberts' code.
> > 
> > Worst case for either implementation is a list length just over a POT,
> > and to roughly the same degree, so here are results for a range of
> > 2^N+1 lengths.  List elements were 16 bytes each including malloc
> > overhead; random initial order.
> 
> This patch breaks UBIFS. I did not have time to dig deeper, but the
> symptoms is that list_sort() calls the 'cmp()' function with bogus
> 'struct list_head *a' parameter, which did not exist in the original
> list.

Sorry, it appeared to be that UBIFS 'cmp()' function is broken, so your
patches revealed the issue. Sorry for noise and thanks for revealing
UBIFS problem!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

