Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab1CaN1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:27:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab1CaN1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:27:37 -0400
Subject: perf and cgroup event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 31 Mar 2011 15:27:07 +0200
Message-ID: <1301578027.4859.256.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

while trying to make sense of various other fun event scheduling issues,
I noticed that perf_cgroup_switch() isn't always doing the right thing.

So we typically want to schedule: CPU-pinned, TASK-pinned, CPU-flexible
TASK-flexible, however the current code doesn't respect that.

In particular perf_cgroup_sched_in() is placed wrong, it should be
_before_ we schedule in the task contexts.

There's further complications with things like perf_install_in_context()
and perf_cgroup_move(), but those are either rare or 'interesting' to
fix.


