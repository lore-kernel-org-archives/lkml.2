Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0GAPCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:02:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58771 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab0GAPCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:02:47 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       MattFleming <matt@console-pimps.org>
In-Reply-To: <1277994970.1917.184.camel@laptop>
References: <20100624142804.431553874@chello.nl>
	 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
	 <1277464589.32034.276.camel@twins>
	 <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
	 <1277477401.32034.670.camel@twins>  <1277994970.1917.184.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Jul 2010 17:02:35 +0200
Message-ID: <1277996555.1917.205.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 16:36 +0200, Peter Zijlstra wrote:
> 
> Pushed out a new git tree with the below delta folded in.
> 
Said tree also cures x86 and folds the SH build fix.

Matt, you said it broke SH completely, but did you try perf stat? perf
record is not supposed to work on SH due to the hardware not having an
overflow interrupt.

Which made me think, what on SH guarantees we update the counter often
enough not to suffer from counter wrap? Would it make sense to make the
SH code hook into their arch tick handler and update the counters from
there?
