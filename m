Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1ASUTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:19:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab1ASUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:19:32 -0500
Date: Wed, 19 Jan 2011 12:18:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [Patch] printk: move some loglevel setup functions to
 kernel/printk.c
Message-Id: <20110119121855.c529f84f.akpm@linux-foundation.org>
In-Reply-To: <1295422165-22269-1-git-send-email-amwang@redhat.com>
References: <1295422165-22269-1-git-send-email-amwang@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Cc: WANG Cong <amwang@redhat.com>, Ingo Molnar <mingo@elte.hu> (commit_signer:8/43=19%,commit_signer:4/26=15%), Andrew Morton <akpm@linux-foundation.org> (commit_signer:7/43=16%,commit_signer:9/26=35%), Peter Zijlstra <a.p.zijlstra@chello.nl> (commit_signer:5/43=12%), Tejun Heo <tj@kernel.org> (commit_signer:4/43=9%), Arnd Bergmann <arnd@arndb.de> (commit_signer:3/43=7%), James Morris <jmorris@namei.org> (commit_signer:6/26=23%), Kees Cook <kees.cook@canonical.com> (commit_signer:4/26=15%), Namhyung Kim <namhyung@gmail.com> (commit_signer:3/26=12%)

Pease don't do that.

On Wed, 19 Jan 2011 15:29:24 +0800
Amerigo Wang <amwang@redhat.com> wrote:

> These parameter setup functions should go to kernel/printk.c,

That makes sense.

> and should also be under CONFIG_PRINTK.

Not so sure about that.  console_loglevel pertains to the console
system more than to printk.  And the console layer is present even when
CONFIG_PRINTK=n.

Now, it may be that console_loglevel never does anything useful when
CONFIG_PRINTK=n.  In which case one wonders why the console code exists
when CONFIG_PRINTK=n.

Anyway.  I didn't look at all this terribly hard.  Please demonstrate
to us that you did do so :)

