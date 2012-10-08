Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2JHUfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:35:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40748 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2JHUe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:34:59 -0400
Message-ID: <507338EF.3060801@gmail.com>
Date: Mon, 08 Oct 2012 14:34:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: Re: [PATCH 07/12] perf kvm: handle realloc failures
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com> <1349716656-48165-8-git-send-email-dsahern@gmail.com> <20121008201956.GE2631@ghostprotocols.net>
In-Reply-To: <20121008201956.GE2631@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/12 2:19 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Oct 08, 2012 at 11:17:31AM -0600, David Ahern escreveu:
>> Save previous pointer and free on failure.
>
> <SNIP>
>
>> +	prev = event->vcpu;
>>   	event->vcpu = realloc(event->vcpu,
>>   			      event->max_vcpu * sizeof(*event->vcpu));
>>   	if (!event->vcpu) {
>> +		free(prev);
>>   		pr_err("Not enough memory\n");
>
> Unfamiliar way of doing it, usually we do it like:
>
>    	vcpu = realloc(event->vcpu, event->max_vcpu * sizeof(*event->vcpu));
>
> 	if (!vcpu) {
>    		pr_err("Not enough memory\n");
> 		return -1;
> 	}
>
> 	event->vcpu = vcpu;
>
> I.e. we don't trow away the old value of event->vcpu.

right. Command is going to exit on a failure, so leaving the old value 
does not have any impact. I can leave the old if you want it for 
consistency.

David

