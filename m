Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab2J2Psh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:48:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950Ab2J2Ps2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:48:28 -0400
Date: Mon, 29 Oct 2012 12:54:23 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/8] perf ui/browser: Integrate script browser into
 main hists browser
Message-ID: <20121029145423.GF6754@infradead.org>
References: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
 <1351569369-26732-6-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351569369-26732-6-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 30, 2012 at 11:56:06AM +0800, Feng Tang escreveu:
> Integrate the script browser into "perf report" framework, users can
> use function key 'r' or the drop down menu to list all perf scripts
> and select one of them, just like they did for the annotation.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>

I noticed this comment on another patch:

--------------------------
This initial version only enables it for 'perf report', by checking
the "timer" parameter of perf_evsel__hists_browser() equals NULL.
--------------------------

Yeah, one can say that if a timer is provided, we can say its 'top' and
not 'report', at least as things stand now.

So please add a 'is_top(void *timer)' so that we know the intent more
clearly and use it to avoid showing the 'r' key when in 'top' mode, ok?

- Arnaldo
