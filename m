Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1BGWbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:31:00 -0500
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:35424 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1BGWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:30:58 -0500
Message-ID: <4D50723B.7020400@genband.com>
Date: Mon, 07 Feb 2011 16:29:15 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RFC: /proc/<pid>/sched should contain cumulative data for all threads
 in process
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Feb 2011 22:29:16.0094 (UTC) FILETIME=[74151DE0:01CBC716]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17942.001
X-TM-AS-Result: No--21.004800-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

We've got a tool that gathers lots of scheduling data for each process
(not task/thread) on the system.

For /proc/<pid>/{stat,io} this is straightforward, as the per-thread
values are summed together for the process as a whole.

However, /proc/<pid>/sched only shows the data for the individual thread
with the same tid as the pid.  To get a per-process view we need to
manually scan all the threads and sum them--and this can get expensive
due to all the extra file operations, parsing, etc.

Was this a concious design decision, or just an oversight?  Would a
patch converting it to whole-process values be accepted or is it enough
of a standard interface that we can't break existing apps that expect
the current behaviour?

Thanks,
Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
