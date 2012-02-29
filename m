Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2B2UNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:13:12 -0500
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:62648 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957Ab2B2UNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:13:10 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Feb 2012 15:13:10 EST
X-AuditID: 12074424-b7fae6d000000906-a0-4f4e85a9d542
Message-ID: <4F4E859E.9030902@mit.edu>
Date: Wed, 29 Feb 2012 12:07:58 -0800
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 0/4] time/timekeeping: Simplify vsyscall locking
References: <20120228194200.180923135@linutronix.de>
In-Reply-To: <20120228194200.180923135@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsUixCmqrbuy1c/fYNIFPotpG8UtzvzWtbi8
	aw6bxZZLzawWx3sPMFls3jSV2eLNhXssDuwet9r+MHtsXqHlsXjPSyaPO9f2sHm8O3eO3ePz
	JjmPEy1fWAPYo7hsUlJzMstSi/TtErgyFhycyV6wjKXi3swvjA2MG5m7GDk5JARMJN7vusoI
	YYtJXLi3ng3EFhLYxyhxYZlhFyMXkL2BUaKx8S4LhPOCSWLB5UNAVRwcvAJqEms3aoA0sAio
	Smz8fgZsKJuAikTH0gdMILaoQITEnrV/weK8AoISJ2c+YQGx+QTkJCZufQYWFxHQkNh46RYz
	yHxmgYeMEgdbDoBdJCzgInHi5V0WiItMJD6feAxmcwqYSsyceAnsUmYBHYl3fQ+YIWx5ie1v
	5zBPYBSahWTfLCRls5CULWBkXsUom5JbpZubmJlTnJqsW5ycmJeXWqRrrpebWaKXmlK6iREU
	NewuKjsYmw8pHWIU4GBU4uFlLPTzF2JNLCuuzD3EKMnBpCTKu7UFKMSXlJ9SmZFYnBFfVJqT
	WnyIUYKDWUmE960UUI43JbGyKrUoHyYlzcGiJM6rofXOT0ggPbEkNTs1tSC1CCYrw8GhJMFb
	DDJUsCg1PbUiLTOnBCHNxMEJMpwHaPg6kBre4oLE3OLMdIj8KUZFKXHebSAJAZBERmkeXC8s
	qb1iFAd6RZh3NkgVDzAhwnW/AhrMBDQ4gNMbZHBJIkJKqoFxss7EP7kzzl9mP5S7/JsR2/8d
	k+tr3jC6BF+eOyVio+FHdwOlM7M1YjjE/h44525kG3Fnsj53TZ+8/Dr3xVcDkuPSUjZv3vLo
	3F22urBd8xNbk04FZ15wZerZ9PXAwd+qpY0mrXv4ojr+pDikTeHz3Z8s7yD0v3ufyE9Pqb3r
	jrpyeYvXL7mpxFKckWioxVxUnAgAUDlfF0UDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 11:46 AM, Thomas Gleixner wrote:
> vsyscall updates have a separate seqlock which nests into
> xtime_lock. There is no point to grab another lock for nothing. All it
> needs is to update the seqcount which is user space visible.
> 
> The following series cleans that up.

FWIW, patches 2 and 3 are
Reviewed-by: Andy Lutomirski <luto@amacapital.net>

Can you let me know when these hit a git tree somewhere?  I have two
more vdso clock speedups I want to send for 3.4, and I'll rebase them on
top of these.

Thanks,
Andy
