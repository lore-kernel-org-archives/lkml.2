Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0EJIE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:04:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:45242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab0EJIE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:04:27 -0400
Subject: Re: [PATCH] perf_event: Make software events work again
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, eranian@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100508105800.GB10650@brick.ozlabs.ibm.com>
References: <20100508105800.GB10650@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 May 2010 10:04:12 +0200
Message-ID: <1273478652.5605.3325.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 20:58 +1000, Paul Mackerras wrote:
> Commit 6bde9b6ce0127e2a56228a2071536d422be31336 ("perf: Add group
> scheduling transactional APIs") added code to allow a group to be
> scheduled in a single transaction.  However, it introduced a bug in
> handling events whose pmu does not implement transactions -- at the
> end of scheduling in the events in the group, in the non-transactional
> case the code now falls through to the group_error label, and proceeds
> to unschedule all the events in the group and return failure.
> 
> This fixes it by returning 0 (success) in the non-transactional case.

D'0h I should have spotted that :/

Thanks Paul!
