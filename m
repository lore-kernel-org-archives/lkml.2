Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1GTAHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:07:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16690 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1GTAHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:07:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:x-system-of-record;
	b=vc/D/UH0s+RC/3PSycBefLRxXuZZYzt4W2iVmUaT6brebpF9T58vK5QWnUORSKtre
	kOS8peAcv4GvXs6LU9U5w==
Date: Tue, 19 Jul 2011 17:07:38 -0700
From: Todd Poynor <toddpoynor@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Crash in schedule path after worker thread dies
Message-ID: <20110720000738.GA18774@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a worker thread died due to a bug in a work function, a NULL
dereference was seen when schedule calls wq_worker_sleeping calls
kthread_data:

          return to_kthread(task)->data;

mm_release has apparently already set the task's vfork_done = NULL,
causing to_kthread to return a bad address (on 3.0-rc7 on ARM).

I haven't tried a fix because I'm not sure if avoiding this case is
enough to properly recover from death of a worker thread, or if this
has already been discussed and rejected in the past.  I searched
around a little and found some mentions of problems in worker
functions that were probably followed by the kthread_data crash,
but didn't turn up any specific discussion of this crash.  So I
thought I'd start by mentioning this here, and can help fix or test if
needed.


Todd
