Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2IRR3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:29:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:30566 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab2IRR3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:29:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,444,1344236400"; 
   d="scan'208";a="146401013"
From: Andi Kleen <andi@firstfloor.org>
To: acme@ghostprotocols.net, jolsa@redhat.com,
        Zheng Yan <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Current perf tool does not compile anymore on RHEL6
Date: Tue, 18 Sep 2012 10:29:48 -0700
Message-ID: <m2fw6fxmr7.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Presumably flex-2.5.35-8.el6.x86_64 doesn't support YY_EXTRA

Problem started with

commit 90e2b22dee908c13df256140a0d6527e3e8ea3f4
Author: Jiri Olsa <jolsa@redhat.com>
Date:   Fri Jun 15 14:31:40 2012 +0800

    perf/tool: Add support to reuse event grammar to parse out terms


Unfortunately needs several other patches reverted too to revert.


    CC /home/ak/lsrc/obj-perf/util/symbol.o
util/parse-events.c: In function ‘parse_events__scanner’:
util/parse-events.c:695: warning: implicit declaration of function
‘parse_events_lex_init_extra’
util/parse-events.c:695: warning: nested extern declaration of
‘parse_events_lex_init_extra’
util/parse-events.c:699: error: too many arguments to function
‘parse_events__scan_string’
util/parse-events.c:706: error: too many arguments to function
‘parse_events__flush_buffer’
util/parse-events.c:707: error: too many arguments to function
‘parse_events__delete_buffer’
util/parse-events.c:708: error: too many arguments to function
‘parse_events_lex_destroy’
util/parse-events.c: In function ‘parse_events_terms’:
util/parse-events.c:722: error: ‘PE_START_TERMS’ undeclared (first use
in this function)
util/parse-events.c:722: error: (Each undeclared identifier is reported
only once
util/parse-events.c:722: error: for each function it appears in.)
util/parse-events.c: In function ‘parse_events’:
util/parse-events.c:741: error: ‘PE_START_EVENTS’ undeclared (first use
in this function)


-- 
ak@linux.intel.com -- Speaking for myself only
