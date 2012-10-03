Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2JCUKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:10:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2JCUKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:10:14 -0400
Date: Wed, 3 Oct 2012 13:10:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [patch] mm, thp: fix mlock statistics
Message-Id: <20121003131012.f88b0d66.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1209271814340.2107@eggly.anvils>
References: <alpine.DEB.2.00.1209191818490.7879@chino.kir.corp.google.com>
	<alpine.LSU.2.00.1209192021270.28543@eggly.anvils>
	<alpine.DEB.2.00.1209261821380.7745@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1209261929270.8567@chino.kir.corp.google.com>
	<alpine.LSU.2.00.1209271814340.2107@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 18:32:33 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> So despite my earlier reluctance, please take this as an Ack on that
> one too (I was testing them together): it'll be odd if one of them goes
> to stable and the other not, but we can sort that out with GregKH later.

Yes, all this code has changed so much since 3.6 that new patches will
need to be prepared for -stable.

The free_page_mlock() hunk gets dropped because free_page_mlock() is
removed.  And clear_page_mlock() doesn't need this treatment.  But
please check my handiwork.

