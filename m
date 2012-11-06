Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab2KFVbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:31:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab2KFVbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:31:38 -0500
Date: Tue, 6 Nov 2012 16:31:28 -0500
From: Dave Jones <davej@redhat.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] procfs: /proc/sched_debug fails on very very large
 machines.
Message-ID: <20121106213128.GB1762@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nathan Zimmer <nzimmer@sgi.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
References: <1352235741-26478-1-git-send-email-nzimmer@sgi.com>
 <1352235741-26478-2-git-send-email-nzimmer@sgi.com>
 <1352235741-26478-3-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352235741-26478-3-git-send-email-nzimmer@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 03:02:21PM -0600, Nathan Zimmer wrote:
 > On systems with 4096 cores attemping to read /proc/sched_debug fails.
 > We are trying to push all the data into a single kmalloc buffer.
 > The issue is on these very large machines all the data will not fit in 4mb.
 > 
 > A better solution is to not us the single_open mechanism but to provide
 > our own seq_operations and treat each cpu as an individual record.

Good timing.

This looks like it would solve the problem I just reported here:
https://lkml.org/lkml/2012/11/6/390

That happens even on an 8-way, so it's not just niche machines that have
this problems.

	Dave

