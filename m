Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab0KXAN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:13:57 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49907 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab0KXAN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:13:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ben Gamari <bgamari@gmail.com>
Subject: Re: [RFC 1/2] deactive invalidated pages
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <87hbf89jfk.fsf@gmail.com>
References: <20101122143817.E242.A69D9226@jp.fujitsu.com> <87hbf89jfk.fsf@gmail.com>
Message-Id: <20101124091249.7BEB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 24 Nov 2010 09:13:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 23 Nov 2010 16:16:55 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > By Other approach, app developer uses POSIX_FADV_DONTNEED.
> > > But it has a problem. If kernel meets page is writing
> > > during invalidate_mapping_pages, it can't work.
> > > It is very hard for application programmer to use it.
> > > Because they always have to sync data before calling
> > > fadivse(..POSIX_FADV_DONTNEED) to make sure the pages could
> > > be discardable. At last, they can't use deferred write of kernel
> > > so that they could see performance loss.
> > > (http://insights.oetiker.ch/linux/fadvise.html)
> > 
> > If rsync use the above url patch, we don't need your patch. 
> > fdatasync() + POSIX_FADV_DONTNEED should work fine.
> > 
> This is quite true, but the patch itself is fairly invasive and
> unnecessarily so which makes it unsuitable for merging in the eyes of
> the rsync maintainers (not that I can blame them). This is by no fault
> of its author; using fadvise is just far harder than it should be.

Yeah. I agree with this patch don't have negative impact. I was only
curious why Minchan drop autodetect logic.

Please don't think I'm against your effort.

Thanks.


