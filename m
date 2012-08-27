Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2H0Ten (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 15:34:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40779 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab2H0Tel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 15:34:41 -0400
Message-ID: <503BCBCC.8060509@gmail.com>
Date: Mon, 27 Aug 2012 13:34:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Dong Hao <haodong@linux.vnet.ibm.com>, avi@redhat.com, acme@infradead.org,
        mtosatti@redhat.com, mingo@elte.hu, xiaoguangrong@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com> <20120827155331.GA18224@turtle.usersys.redhat.com>
In-Reply-To: <20120827155331.GA18224@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/12 9:53 AM, Andrew Jones wrote:
> On Mon, Aug 27, 2012 at 05:51:46PM +0800, Dong Hao wrote:
>
> <snip>
>
>> +struct event_stats {
>> +	u64 count;
>> +	u64 time;
>> +
>> +	/* used to calculate stddev. */
>> +	double mean;
>> +	double M2;
>> +};
>
> How about moving the stats functions from builtin-stat.c to e.g.
> util/stats.c, and then reusing them? Then this struct (which I would
> rename to kvm_event_stats) would look like this
>
> struct kvm_event_stats {
>          u64 time;
>          struct stats stats;
> };
>
> of course the get_event_ accessor generators would need tweaking

Given the history of the command (first submitted back in February) code 
refactoring can wait until there is a second user for the stats code.

David
