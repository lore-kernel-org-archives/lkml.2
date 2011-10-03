Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1JCQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1JCQZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:25:53 -0400
Date: Mon, 3 Oct 2011 13:25:33 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        dsahern@gmail.com
Subject: Re: [PATCH] perf: fix broken number of samples for perf report -n
Message-ID: <20111003162532.GA24281@ghostprotocols.net>
References: <20111003093815.GA6393@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003093815.GA6393@quad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 03, 2011 at 11:38:15AM +0200, Stephane Eranian escreveu:
> 
> The perf report -n option was broken because it was not reporting
> the correct number of samples depending on the sorting mode. By
> default, samples are sorted by comm,dso,sym. That means that
> samples for the same command (binary) get collapsed.
> 
> The hists__collapse_insert_entry() had a bug whereby
> it was aggregating the number of events observed (periods)
> but not the number of samples. Consequently, the number
> of samples reported could be below reality. The percentage
> remained correct because based on the periods.
> 
> This patch fixes the problem by also aggregating
> the number of samples. Here is an example:

Eagle eyes, this collapse_resort thing has its issues, been fighting
some last week, making 'perf top' use struct hist_entry, killing code.

Double checking that now, thanks!

- Arnaldo
