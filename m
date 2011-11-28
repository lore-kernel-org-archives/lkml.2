Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1K1QFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:05:03 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:4797 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab1K1QFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:05:01 -0500
Message-ID: <4ED3B118.50502@parallels.com>
Date: Mon, 28 Nov 2011 20:04:40 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] sysctl: Add the kernel.ns_last_pid control
References: <4ED3A6F5.6070606@parallels.com> <20111128155315.GA18864@google.com>
In-Reply-To: <20111128155315.GA18864@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 07:53 PM, Tejun Heo wrote:
> On Mon, Nov 28, 2011 at 07:21:25PM +0400, Pavel Emelyanov wrote:
>> +static int pid_ns_ctl_handler(struct ctl_table *table, int write,
>> +		void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +	struct ctl_table tmp = *table;
>> +
>> +	if (write && !capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
>> +	/*
>> +	 * Writing directly to ns' last_pid field is OK, since this field
>> +	 * is volatile in a living namespace anyway and a code writing to
>> +	 * it should synchronize its usage with external means.
>> +	 */
> 
> I would still prefer using set_last_pid() but if you insist to update
> last_pid directly, please note the direct update in the comment on top
> of set_last_pid() too.

It's already there in this patch.

> Other than that,
> 
>   Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

> Thanks.
> 

