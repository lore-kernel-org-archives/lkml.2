Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2CEP5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:57:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60456 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab2CEP5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:57:08 -0500
Date: Mon, 5 Mar 2012 16:56:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        asharma@fb.com, robert.richter@amd.com, ming.m.lin@intel.com,
        vweaver1@eecs.utk.edu, andi@firstfloor.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120305155642.GB32413@elte.hu>
References: <20120224094048.GA7952@quad>
 <20120305154753.GA14604@elte.hu>
 <20120305155011.GA32413@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305155011.GA32413@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A third usability bug is that for some reason a branch sampling 
'perf report' defaults to the stdio output on my testsystem - 
with --no-branch-stack it gives the regular tui.

Even specifying --tui explicitly does not restore the TUI. Is 
there any fundamental reason why the branch stack does not 
support the TUI?

A fourth bug is that regular profiling appears to be busted:

 aldebaran:> perf record -a sleep 1
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.026 MB perf.data (~1120 samples) ]

 aldebaran:~> perf report
 Warning: TUI interface not supported in branch mode
 selected -b but no branch data. Did you call perf record without -b?

Guys, why are you sending me these patches? The tooling side is 
utterly untested and very raw yet.

Thanks,

	Ingo
