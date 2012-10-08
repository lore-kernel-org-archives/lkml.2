Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2JHVi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:38:58 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59107 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2JHVi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:38:56 -0400
Date: Mon, 8 Oct 2012 14:38:50 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: Re: [PATCH 07/12] perf kvm: handle realloc failures
Message-ID: <20121008213850.GL2631@ghostprotocols.net>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
 <1349716656-48165-8-git-send-email-dsahern@gmail.com>
 <20121008201956.GE2631@ghostprotocols.net>
 <507338EF.3060801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507338EF.3060801@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 08, 2012 at 02:34:55PM -0600, David Ahern escreveu:
> On 10/8/12 2:19 PM, Arnaldo Carvalho de Melo wrote:
> >>+	prev = event->vcpu;
> >>  	event->vcpu = realloc(event->vcpu,
> >>  			      event->max_vcpu * sizeof(*event->vcpu));
> >>  	if (!event->vcpu) {
> >>+		free(prev);
> >>  		pr_err("Not enough memory\n");

> >Unfamiliar way of doing it, usually we do it like:

> >   	vcpu = realloc(event->vcpu, event->max_vcpu * sizeof(*event->vcpu));

> >	if (!vcpu) {
> >   		pr_err("Not enough memory\n");
> >		return -1;
> >	}

> >	event->vcpu = vcpu;

> >I.e. we don't trow away the old value of event->vcpu.
> 
> right. Command is going to exit on a failure, so leaving the old
> value does not have any impact. I can leave the old if you want it
> for consistency.

I think do it in the familiar way for consistency.

- Arnaldo
