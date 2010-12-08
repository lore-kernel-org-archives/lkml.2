Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0LHPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:25:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:36924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab0LHPZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:25:28 -0500
Message-ID: <4CFFA31E.6080709@kernel.org>
Date: Wed, 08 Dec 2010 16:24:14 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 05/11] core: Replace __get_cpu_var with __this_cpu_read
 if not used for an address.
References: <20101206171618.302060721@linux.com> <20101206171639.183187260@linux.com> <4CFE44E2.9050408@kernel.org> <alpine.DEB.2.00.1012070850060.25976@router.home> <4CFE510E.2010007@kernel.org> <alpine.DEB.2.00.1012070937440.26552@router.home>
In-Reply-To: <alpine.DEB.2.00.1012070937440.26552@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 15:24:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 04:38 PM, Christoph Lameter wrote:
> On Tue, 7 Dec 2010, Tejun Heo wrote:
> 
>> Can you please fold this into the original patch and resend?  I
>> skipped 04, 05 and 09.  percpu#for-next now contains other patches.
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next
>>
>> Thanks.
> 
> Subject: core: Replace __get_cpu_var with __this_cpu_read if not used for an address.
> 
> __get_cpu_var() can be replaced with this_cpu_read and will then use a single
> read instruction with implied address calculation to access the correct per cpu
> instance.
> 
> However, the address of a per cpu variable passed to __this_cpu_read() cannot be
> determed (since its an implied address conversion through segment prefixes).
> Therefore apply this only to uses of __get_cpu_var where the addres of the
> variable is not used.
> 
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied.  Thanks.

-- 
tejun
