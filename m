Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab0EHCYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 22:24:53 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58952 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0EHCYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 22:24:52 -0400
Message-ID: <4BE4CB71.60702@linux.vnet.ibm.com>
Date: Fri, 07 May 2010 19:24:49 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>
CC: Stephane Eranian <eranian@googlemail.com>
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled /
 running values are incorrect
References: <4BE4C4BF.6020801@linux.vnet.ibm.com>
In-Reply-To: <4BE4C4BF.6020801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 06:56 PM, Corey Ashford wrote:
> Hi,
>
> There appears to be a bug in the kernel related to reading up the time
> running and enabled values for events that are in a group. The group
> leader's time running and time enable values look correct, but all of
> the other group members have a zero value for their time running and
> time enabled fields.
>
> This happens only when remote monitoring a process (perhaps only after
> it has terminated)... when self monitoring, the time running/enabled
> values come out non-zero, and the values are the same for all of the
> counters (as one would expect since they can be enabled/disabled
> simultaneously).
>
> I've attached a test case which you can place in the tools/perf
> subdirectory and compile with just:
>
> gcc -o show_re_bug show_re_bug.c

I forgot to mention that you should run this with some sort of the load 
program, like

./show_re_bug md5sum `which gdb`

- Corey
