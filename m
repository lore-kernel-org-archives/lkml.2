Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0KGWPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:15:10 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:45340 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab0KGWPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:15:08 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/4] memcg: variable type fixes
Date: Sun,  7 Nov 2010 23:14:35 +0100
Message-Id: <20101107215030.007259800@cmpxchg.org>
X-Mailer: git-send-email 1.7.2.3
User-Agent: quilt/0.48-1
In-Reply-To: <AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com> <20101106010357.GD23393@cmpxchg.org> <AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

it is not the res counter primitives, these are our own counters.  We
have to keep signed types for most counters, as the per-cpu counter
folding can race and we end up with negative values.

The fix for the original issue is in patch 1.  There are no casts
needed, the range is checked to be sane and then converted to the
unsigned type through assignment.

Patch 2, also a type fix, ensures we catch accounting races properly.
It is unrelated, but also important.

Patch 3 implements the idea that we only have to used signed types for
_some_ of the counters, but not for constant event counters where the
sign-bit would be a waste.

Patch 4 converts our fundamental page statistics counters to native
words as these should be wide enough for the expected values.

	Hannes

