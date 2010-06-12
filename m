Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0FLJot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 05:44:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:45171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0FLJor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 05:44:47 -0400
Subject: Re: [PATCH 3/5] perf: Ability to enable in a paused mode
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1276328098-24114-4-git-send-regression-fweisbec@gmail.com>
References: <1276328098-24114-1-git-send-regression-fweisbec@gmail.com>
	 <1276328098-24114-4-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 12 Jun 2010 11:44:26 +0200
Message-ID: <1276335866.2077.3097.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-12 at 09:34 +0200, Frederic Weisbecker wrote:
>  struct pmu {
>         int (*enable)                   (struct perf_event *event);
> +       /*
> +        * Reserve acts like enable, except the event must go in a "pause"
> +        * state. Ie: it is scheduled but waiting to be started
> +        * with the ->start() callback.
> +        */
> +       int (*reserve)                  (struct perf_event *event);
>         void (*disable)                 (struct perf_event *event); 

Urgh, so then we have, enable(), reserve() and start(), that's just too
much. Also, you need to visit all pmu implementations if you touch
struct pmu like that.
