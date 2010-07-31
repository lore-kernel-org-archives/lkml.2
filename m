Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0GaSJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 14:09:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42355 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0GaSJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 14:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tWIafzVDISlLQ6kCnXts235eTcef34n1kCG9p9bw42B3335gpn1y6liKlKO17ocxsY
         QHXvUBNxu+Tm1ZHVNeyJ7dzo6KdAxHprBSdyNI8sFJnXl7tyj/pBEww3X+UZHDODrOYy
         PFOLwvepnkizdV7zmnLlM+RntQn0zEfWuzZ48=
MIME-Version: 1.0
In-Reply-To: <20100731175951.GA17519@infradead.org>
References: <20100728071705.GA22964@localhost>
	<20100731161358.GA5147@localhost>
	<20100731173328.GA21072@infradead.org>
	<AANLkTi=+muw_2jWq1QKsxp6A_fAtdhdns7MD_bKQo-72@mail.gmail.com>
	<20100731175951.GA17519@infradead.org>
Date: Sat, 31 Jul 2010 21:09:35 +0300
X-Google-Sender-Auth: 3kUC0kkclODjq9Eq-i6fWO0ZqzM
Message-ID: <AANLkTikG7UOSh=iH02YwO0ihpu2waKt3bHH7LLK-33MP@mail.gmail.com>
Subject: Re: [PATCH] vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 8:59 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Jul 31, 2010 at 08:55:57PM +0300, Pekka Enberg wrote:
>> Do you have CONFIG_SLUB enabled? It does high order allocations by
>> default for performance reasons.
>
> Yes. This is a kernel using slub.

You can pass "slub_debug=o" as a kernel parameter to disable higher
order allocations if you want to test things. The per-cache default
order is calculated in calculate_order() of mm/slub.c. How many CPUs
do you have on your system?
