Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1IIXuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:50:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab1IIXuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:50:12 -0400
Date: Fri, 9 Sep 2011 16:49:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>, Vladimir Zapolskiy <vz@mleia.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sched: share task comm length value to userspace
Message-Id: <20110909164959.237a8612.akpm@linux-foundation.org>
In-Reply-To: <20110909164130.3bc63ff7.akpm@linux-foundation.org>
References: <1315247881-31597-1-git-send-email-vz@mleia.com>
	<20110905124726.28b24db4@infradead.org>
	<4E652E41.1030308@mleia.com>
	<20110905133903.76cd3a61@infradead.org>
	<20110909164130.3bc63ff7.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Sep 2011 16:41:30 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 		if (prctl(PR_GET_NAME, (unsigned long)comm2, 0, 0, 0) < 0) {

Actually, if we were ever to increase sizeof(task_struct.comm),
existing code which does

	char comm[16];
	prctl(PR_GET_NAME, comm, ...)

will get its stack scribbled on.

So we _could_ increase it, but we'd need to retain the old 16-char
interfaces and add new prctl() modes.  And if we did that, we'd design
them in such a way that userspace wouldn't need to assume a fixed
size..

