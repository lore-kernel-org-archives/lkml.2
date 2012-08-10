Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab2HJUhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 16:37:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36425 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2HJUhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 16:37:13 -0400
Message-ID: <502570F5.3080903@gmail.com>
Date: Fri, 10 Aug 2012 14:37:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Dong Hao <haodong@linux.vnet.ibm.com>
CC: avi@redhat.com, acme@infradead.org, mtosatti@redhat.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 3/3] KVM: perf kvm events analysis tool
References: <1344568750-5147-1-git-send-email-haodong@linux.vnet.ibm.com> <1344568750-5147-4-git-send-email-haodong@linux.vnet.ibm.com>
In-Reply-To: <1344568750-5147-4-git-send-email-haodong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for resubmitting this; it was on my to-do list as well.

On 8/9/12 9:19 PM, Dong Hao wrote:
> +static bool kvm_events_exist(const char *event)
> +{
> +	char evt_path[MAXPATHLEN];
> +	int fd;
> +
> +	snprintf(evt_path, MAXPATHLEN, "%s/kvm/%s/id", tracing_events_path,
> +		 event);
> +
> +	fd = open(evt_path, O_RDONLY);

Use is_valid_tracepoint().

For consistency, it's worth adding a check for the other events too with 
an appropriate config message. e.g.,:
   https://lkml.org/lkml/2012/8/9/359

David
