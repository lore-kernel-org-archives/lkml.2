Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2JHUUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:20:08 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:58294 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2JHUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:20:04 -0400
Date: Mon, 8 Oct 2012 13:19:56 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: Re: [PATCH 07/12] perf kvm: handle realloc failures
Message-ID: <20121008201956.GE2631@ghostprotocols.net>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
 <1349716656-48165-8-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349716656-48165-8-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 08, 2012 at 11:17:31AM -0600, David Ahern escreveu:
> Save previous pointer and free on failure.

<SNIP>
 
> +	prev = event->vcpu;
>  	event->vcpu = realloc(event->vcpu,
>  			      event->max_vcpu * sizeof(*event->vcpu));
>  	if (!event->vcpu) {
> +		free(prev);
>  		pr_err("Not enough memory\n");

Unfamiliar way of doing it, usually we do it like:

  	vcpu = realloc(event->vcpu, event->max_vcpu * sizeof(*event->vcpu));

	if (!vcpu) {
  		pr_err("Not enough memory\n");
		return -1;
	}

	event->vcpu = vcpu;

I.e. we don't trow away the old value of event->vcpu.

- Arnaldo
