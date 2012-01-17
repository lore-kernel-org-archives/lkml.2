Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2AQPEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:04:30 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52907 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2AQPE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:04:29 -0500
MIME-Version: 1.0
In-Reply-To: <1326811093.3467.41.camel@lenny>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326811093.3467.41.camel@lenny>
Date: Tue, 17 Jan 2012 17:04:28 +0200
X-Google-Sender-Auth: 7i0QmhphMlM_T1kFc208ApsZ630
Message-ID: <CAOJsxLG6Q=zr8kqcds7jWzpGqqy2GV10YERb9njMzM8y7kS55A@mail.gmail.com>
Subject: Re: [RFC 0/3] low memory notify
From: Pekka Enberg <penberg@kernel.org>
To: Colin Walters <walters@verbum.org>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
        mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 4:38 PM, Colin Walters <walters@verbum.org> wrote:
> So what you really want to be investigating here is integration between
> a garbage collector and the system VM.  Your test program looks nothing
> like a garbage collector.  I'd expect most of the performance tradeoffs
> to be similar between these runtimes.  The Azul people have been doing
> something like this: http://www.managedruntime.org/

The interraction isn't all that complex, really. I'd expect most VMs
to simply wake up the GC thread when poll() returns. GCs that are able
to compact the heap can madvise(MADV_DONTNEED) or even munmap() unused
parts of the heap.

                                Pekka
