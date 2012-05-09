Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2EIWI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:08:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494Ab2EIWIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:08:23 -0400
Message-ID: <4FAAEACF.3070405@redhat.com>
Date: Wed, 09 May 2012 23:08:15 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Mike Frysinger <vapier@gentoo.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        pacman@kosh.dhis.org, linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: ptrace.2: PTRACE_KILL needs a stopped process too
References: <20091216004533.22261.qmail@kosh.dhis.org> <CAKgNAkhtu8d0NKcTwWyCA8qWgz8Lag+GcpEE1=YMVe_Nh8XJ9Q@mail.gmail.com> <20120422200459.GA7519@redhat.com> <201205091109.35637.vapier@gentoo.org> <4FAAC706.6000808@redhat.com> <20120509201219.GA32051@redhat.com>
In-Reply-To: <20120509201219.GA32051@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 09:12 PM, Oleg Nesterov wrote:

> tgkill() can kill the wrong process/thread too, although it lessens the risk.

> 
> But I don't really understand the problem. The traced thread can't go away

> until the tracer does wait/detach, and thus its pid can't be reused?


There's the non-leader thread execs and tracer didn't enable
PTRACE_O_TRACEEXEC case at least, while you try to kill the thread that just
execed, I think.  Though that's quite pedantic.  The tracer could prevent this
in other ways.

> May be, "by accident" above means something else, not pid reuse...


Pffft, who writes buggy code anyway?  ;-)

-- 
Pedro Alves
