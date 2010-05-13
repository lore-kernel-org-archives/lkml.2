Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0EMAck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 20:32:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39458 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab0EMAci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 20:32:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 12/12] Use down_read_unfair() for /sys/<pid>/exe and  /sys/<pid>/maps files
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
In-Reply-To: <n2z8d20b11a1005121635qaa544981v620374f43c15945d@mail.gmail.com>
References: <20100513074949.2136.A69D9226@jp.fujitsu.com> <n2z8d20b11a1005121635qaa544981v620374f43c15945d@mail.gmail.com>
Message-Id: <20100513091659.214D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 13 May 2010 09:32:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is it good idea?
> > So I think /proc shouldn't use unfair thing as backdoor.
> > It doesn't only makes performance improvement, but also
> > DoS chance is there.
> 
> I am not entirely surprised that there is some level of opposition to
> this change (which is in part why it went last in the series).
> 
> Besides keeping it internal, would there be ways to make it acceptable
> to the community ? For example, would it be fine if unfair behavior
> was only used if the caller thread runs with root priviledge ?

Umm. seems no good idea.

Why?

In nowadays, root priviledge should be considered to blocked by security module.
but this using way can't combinate with any security module. at least we need 
more proper and security friendly interface.

> In my opinion the optimal behavior would be if the rwsem could be
> allowed to be grabbed unfairly only as long as there are still fair
> readers on it. However, I don't see how to achieve this given that we
> don't want to slow down the regular, fair code paths.

dumb question.
Why do you need to read /proc/<pid>/exec and /proc/<pid>/maps?
To make new /proc files makes help?

IOW, do we really need unfair reader? can't we make more fine grained lock?



