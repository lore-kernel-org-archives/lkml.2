Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031697Ab2CGAui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:50:38 -0500
Received: from mail1.windriver.com ([147.11.146.13]:36147 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031593Ab2CGAuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:50:37 -0500
Date: Tue, 6 Mar 2012 18:49:25 -0600
From: Peter Seebach <peter.seebach@windriver.com>
To: Anton Blanchard <anton@samba.org>
CC: <acme@redhat.com>, <paulus@samba.org>, <peterz@infradead.org>,
        <mingo@elte.hu>, <dsahern@gmail.com>, <fweisbec@gmail.com>,
        <yanmin_zhang@linux.intel.com>, <emunson@mgebm.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120306184925.56eab8ce@wrlaptop>
In-Reply-To: <20120307114249.44275ca3@kryten>
References: <20120307114249.44275ca3@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 11:42:49 +1100
Anton Blanchard <anton@samba.org> wrote:

> This patch fixes repsep_snprintf by clamping the value at size - 1
> which is the maximum snprintf can write before adding the NULL
> terminator.

I would be concerned by this, simply because I at least sometimes
use snprintf-like functions with the understanding that I can check
for overflow by comparing the return value to the size.

... Of course, I think I also make this mistake you describe in other
code, so I'm gonna go look for that.

But simply clamping the value might break code which is relying
on the existing semantics.  (And of course, any snprintf-related
crash or misbehavior is likely to happen only when the planets are
aligned just so...)

Possible alternative:  Check for a provided size value which is
unreasonably large, and if you get one, assume that it's probably
intended to be negative and refuse to write anything.  I don't know
what unreasonably large is, but "large enough that it would have been
negative had it been a signed type" might be a good starting point --
no one should be writing strings that long anyway*.

-s
[*] I am totally ready for someone in twenty years to throw that quote
in my face contemptuously as it shows that I was hopelessly
short-sighted.
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.
