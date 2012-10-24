Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab2JXMdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:33:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:60203 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab2JXMdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:33:13 -0400
Message-ID: <1351081942.23337.1.camel@twins>
Subject: Re: [PATCH 02/11] perf: Do not get values from disabled counters in
 group format read
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 24 Oct 2012 14:32:22 +0200
In-Reply-To: <20121024121406.GA5582@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	 <1350743599-4805-3-git-send-email-jolsa@redhat.com>
	 <1351008789.13456.37.camel@twins>
	 <20121023165040.GA7553@krava.brq.redhat.com>
	 <1351080078.13456.60.camel@twins>
	 <20121024121406.GA5582@krava.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 14:14 +0200, Jiri Olsa wrote:
> 
> well, x86_pmu_read calls x86_perf_event_update, which expects the
> event
> is active.. if it's not it'll update the count from whatever left in
> event.hw.idx counter.. could be uninitialized or used by others..
> 
Oh right, we shouldn't call ->read() unless ->state ==
PERF_EVENT_STATE_ACTIVE. Aside from that, perf_event_count() should
return the 'right' value regardless state (although excluding ERROR
might make sense).
