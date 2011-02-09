Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1BIR26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:28:58 -0500
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:60065 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab1BIR25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:28:57 -0500
Message-ID: <4D52CEC1.2050605@genband.com>
Date: Wed, 09 Feb 2011 11:28:33 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: /proc/<pid>/sched should contain cumulative data for all
 threads in process
References: <4D50723B.7020400@genband.com>	 <1297156865.13327.57.camel@laptop>  <20110208121144.GA7550@elte.hu> <1297172742.13327.102.camel@laptop>
In-Reply-To: <1297172742.13327.102.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2011 17:28:34.0349 (UTC) FILETIME=[C730CDD0:01CBC87E]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17946.000
X-TM-AS-Result: No--13.986500-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 07:45 AM, Peter Zijlstra wrote:
> On Tue, 2011-02-08 at 13:11 +0100, Ingo Molnar wrote:

>> So assuming a tool would want to capture such stats of the system, what would be its 
>> options? Could we do all this via system-wide counters and perf stat alike cheap, 
>> transparent gathering without having to patch/rebuild the kernel?
> 
> Very much depends on what is wanted, but most of the stuff inside those
> files is very specific to the implementation and pinning any of that to
> an ABI is like silly.

Currently we're using the following fields from
/proc/<pid>/task/<tid>/sched:

sum_exec_runtime
wait_sum
wait_max
exec_max
iowait_sum
iowait_count
nr_switches

If there's a better way to get this information (with the precision
available from this interface) then I'd love to hear about it.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
