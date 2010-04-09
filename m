Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab0DITtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:49:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0DITs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:48:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] proc: get_nr_threads() doesn't need ->siglock any
	longer
In-Reply-To: Oleg Nesterov's message of  Monday, 22 March 2010 19:41:30 +0100 <20100322184130.GA3957@redhat.com>
References: <20100322184130.GA3957@redhat.com>
X-Windows: a moment of convenience, a lifetime of regret.
Message-Id: <20100409194853.95D09BD02@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 12:48:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

I'm not entirely sure about the name, but it's probably fine.  There should
be some comments somewhere making clear what "nr" or kind of threads this
refers to.  This is threads created and not yet reaped.  It differs from
the "threads not yet exited" (signal->live) count only during some races
around exit time, and when ptrace is preventing self-reaping.


Thanks,
Roland
