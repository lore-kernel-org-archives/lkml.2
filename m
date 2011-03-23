Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1CWOfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:35:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab1CWOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110323171051.1ADA.A69D9226@jp.fujitsu.com>
References: <20110322200945.B06D.A69D9226@jp.fujitsu.com> <20110323164949.5be6aa48.kamezawa.hiroyu@jp.fujitsu.com>
 <20110323171051.1ADA.A69D9226@jp.fujitsu.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Mar 2011 07:34:43 -0700
Message-ID: <AANLkTimLbaMTHKiuWu5edS4Offf4KZv2TJ+g8BUgzLYt@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86,mm: make pagefault killable
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Andrey Vagin <avagin@openvz.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 1:09 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> When __lock_page_or_retry() return 0, It call up_read(mmap_sem) in this
> function.

Indeed.

> I agree this is strange (or ugly). but I don't want change this spec in
> this time.

I agree that it is strange, and I don't like functions that touch
locks that they didn't take themselves, but since the original point
of the whole thing was to wait for the page without holding the
mmap_sem lock, that function has to do the up_read() early.

                   Linus
