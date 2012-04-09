Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab2DIKNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 06:13:31 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47221 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2DIKN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 06:13:29 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-4c-4f82b63ff86f
From: Namhyung Kim <namhyung.kim@lge.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [RFC][PATCH 00/15] tools: Unify perf and trace-cmd trace event format parsing v2
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
Date: Mon, 09 Apr 2012 19:13:19 +0900
In-Reply-To: <1333666086-6517-1-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Fri, 6 Apr 2012 00:47:51 +0200")
Message-ID: <87d37h6wn4.fsf@youngshil.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri,  6 Apr 2012 00:47:51 +0200, Frederic Weisbecker wrote:
> So I think we really need to restart the debate. We strongly need to make
> progresses in this area so I'm posting this iteration in the hope we
> can move forward. With the coming of uprobes, there are some chances
> that our tracing becomes more important in the future. Let's join
> our efforts.
>

My concern is its error reporting mechanism - being a generic library it
should support various environments like GUI as well as stdio. I see
current warning, pr_stat and die can be overridden via strong symbol
binding but it's just briefly documented and need more explicit handling
IMHO - something like setup/reset_error_functions or so.

In addition, I think we should avoid using die-like functions that can
terminate a client program in the middle of library calls. Instead,
return proper error codes so that the client can handle its failure and
take appropriate actions it needs. Making the library more robust is
also needed of course - please see my other posting today [1].

Thanks,
Namhyung


[1] https://lkml.org/lkml/2012/4/8/177
