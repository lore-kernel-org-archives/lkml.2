Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2FOSfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:35:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52546 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2FOSfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:35:09 -0400
Date: Fri, 15 Jun 2012 20:35:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Cromie <jim.cromie@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20120615183503.GA27556@gmail.com>
References: <1339601367-17834-1-git-send-email-acme@infradead.org>
 <20120614100710.GB19531@gmail.com>
 <20120615171310.GD11550@infradead.org>
 <20120615182818.GA22037@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120615182818.GA22037@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The build does not want to fail anymore :-/

I have no idea what state my tree was in - but I re-applied your 
patches and the failure happened again in 'make -j':

    CC builtin-help.o
    CC builtin-timechart.o
util/parse-events.l: In function ‘__value’:
util/parse-events.l:18:10: error: ‘PE_ERROR’ undeclared (first 
use in this function)
util/parse-events.l:18:10: note: each undeclared identifier is 
reported only once for each function it appears in
util/parse-events.l:20:2: error: ‘parse_events_lval’ undeclared 
(first use in this function)
util/parse-events.l: In function ‘value’:
util/parse-events.l:26:42: error: ‘PE_VALUE’ undeclared (first 
use in this function)

then I took off the last patch and did a 'make' - and the bug 
did not re-trigger, even after applying your patches again.

It could be some sort of build dependency problem with the flex 
files.

Thanks,

	Ingo
