Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0LFCh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 21:37:28 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60274 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0LFCh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:37:27 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Process events in order if recording from multiple CPUs
Date: Mon,  6 Dec 2010 13:37:03 +1100
Message-Id: <1291603026-11785-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are my set of patches to process events in order and solve the bug where
samples would not be attributed correctly if the COMM and MMAP events for them
had not yet been processed.


I ran out of time cleaning these on Friday and hadn't touched them over the
weekend. I see Thomas has now already posted a patch that does most of what the
third patch in this series does, and this series would supersede his patch, my
apologies for not getting these out last week.

In addition to what Thomas' patch does, patch 3 in this series:
 - Enables the PERF_SAMPLE_TIME flag automatically when recording if recording
   from multiple CPUs (ie, if no_inherit is not set). This flag will be
   disabled if the kernel does not support timestamps on every event and was
   not manually requested.
 - Enables ordered_samples in perf report by default.
 - If an event is encountered without a timestamp, fall back to processing in
   file order (otherwise we might process a PERF_RECORD_EXIT event too early).

Thomas' patch does change some names that I did not ('self' -> 'session'), but
those should be pretty straight forward to put in their own patch on top of
these.


The first patch in this series changes how unresolved symbols are printed out
and the second patch moves some debugging output into the trace_event function
to keep the debugging output sensible when processing events by timestamp.


Cheers,
-Ian


