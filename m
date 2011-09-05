Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab1IEToP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:44:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:45002 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1IEToI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:44:08 -0400
Date: Mon, 5 Sep 2011 12:47:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sched: share task comm length value to userspace
Message-ID: <20110905124726.28b24db4@infradead.org>
In-Reply-To: <1315247881-31597-1-git-send-email-vz@mleia.com>
References: <1315247881-31597-1-git-send-email-vz@mleia.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Sep 2011 21:38:01 +0300
Vladimir Zapolskiy <vz@mleia.com> wrote:

> This change allows to get a defined length of task comm in
> userspace. For a moment this value is implied at least in two cases:
> * max length of comm value got from /proc/$pid/stat
> * max string length argument of prctl(PR_[SG]ET_NAME, ...)
> 
> For these reasons it becomes desirable to impart task comm max length
> value to userspace.

I'm sorry but I don't like doing this.

The moment we do this, we never can increase it anymore since userspace
might be using it for its own uses and we'd break it if we changed
this value.

If we need to export this, we should export it in /proc or /sys
somewhere as a dynamic value.....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
