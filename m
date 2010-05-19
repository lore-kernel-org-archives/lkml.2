Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0ESG2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:28:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45971 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0ESG2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:28:54 -0400
Date: Wed, 19 May 2010 08:28:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/5] perf stat: add perf stat -B to pretty print large
 numbers
Message-ID: <20100519062832.GB21294@elte.hu>
References: <1274234900-12162-1-git-send-email-acme@infradead.org>
 <1274234900-12162-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274234900-12162-2-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Stephane Eranian <eranian@google.com>
> 
> It is hard to read very large numbers so provide an 
> option to perf stat to separate thousands using a 
> separator. The patch leverages the locale support of 
> stdio. You need to set your LC_NUMERIC appropriately, 
> for instance LC_NUMERIC=en_US.UTF8. You need to pass -B 
> to activate this feature. This way existing scripts 
> parsing the output do not need to be changed. Here is an 
> example.

I've pulled it, but IMO we should go one step further: 
this feature should be made unconditional. The current 
numbers displayed by perf stat are often human-unreadable.

scripts should not parse pretty-printed output.

We used to have something like that, in the form of:

  perf record --no-samples --stat -e cycles -e instructions -a sleep 1
  perf report -n -t :

But the Newt changes broke this stat-only recording mode. 
Furthermore, there should be a --raw kind out output mode 
for perf stat as well.

Thanks,

	Ingo
