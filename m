Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab0FJQi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:38:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:50658 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489Ab0FJQix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:38:53 -0400
Subject: Re: [PATCH 1/5] perf: Provide a proper stop action for software
 events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100610162858.GD5255@nowhere>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
	 <1276141760-11590-2-git-send-regression-fweisbec@gmail.com>
	 <1276166813.2077.96.camel@twins> <1276168242.2077.134.camel@twins>
	 <20100610161234.GA5255@nowhere> <1276186576.2077.554.camel@twins>
	 <20100610162858.GD5255@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 18:38:34 +0200
Message-ID: <1276187914.2077.579.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 18:29 +0200, Frederic Weisbecker wrote:

> Imagine you have several software and hardware events running on the
> same cpu. Each time you reset this period for a software event, you do
> a hw_pmu_disable() / hw_pmu_enable(), which writes/read the hardware
> register for each hardware events, amongst other wasteful things.

hw_perf_disable/enable() are on their way out. They should be replaced
with a struct pmu callback. We must remove all these weak functions if
we want to support multiple pmus.


