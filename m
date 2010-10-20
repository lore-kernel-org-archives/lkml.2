Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab0JTLRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 07:17:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:36191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0JTLR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:17:29 -0400
Subject: Re: [PATCH] sched_fair.c:find_busiest_group(), kernel 2.6.35.7
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Dickinson <whydna@whydna.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTinpR5QQUkd5VJMyotiEMLZYZdDs5-Jwn3LQ4pC0@mail.gmail.com>
References: <AANLkTinpR5QQUkd5VJMyotiEMLZYZdDs5-Jwn3LQ4pC0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 13:17:27 +0200
Message-ID: <1287573447.3488.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 00:20 -0700, Andrew Dickinson wrote:
> This is a patch to fix the corner case where we're crashing with
> divide_error in find_busiest_group (see
> https://bugzilla.kernel.org/show_bug.cgi?id=16991).
> I don't fully understand what the case is that causes sds.total_pwr to
> be zero in find_busiest_group, but this patch guards against the
> divide-by-zero bug.
> 
> I also added safe-guarding around other routines in the scheduler code
> where we're dividing by power; that's more of a just-in-case and I'm
> definitely open for debate on that.

No.. papering over crap like this is not done. In that BZ there's a
number of suggestions of how/where to track down the actual root cause,
but apparently nobody is interested in doing that.

(I can't reproduce so I can't actually do anything about it).
