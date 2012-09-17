Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2IQUKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:10:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45116 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab2IQUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:10:09 -0400
Message-ID: <5057839D.5020908@gmail.com>
Date: Mon, 17 Sep 2012 14:10:05 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <srostedt@redhat.com>
CC: Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        tzanussi@gmail.com
Subject: Re: perf script: rwtop: SIGALRM and pipe read race
References: <20120914153952.GA8834@turtle.usersys.redhat.com> <505355AF.7000006@gmail.com> <20120914181049.GA16618@turtle.usersys.redhat.com> <505739EF.5010000@gmail.com> <50573EC3.6020209@gmail.com> <20120917160211.GC31375@ghostprotocols.net> <505750A4.9080207@gmail.com> <20120917171257.GD31375@ghostprotocols.net>
In-Reply-To: <20120917171257.GD31375@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/12 11:12 AM, Arnaldo Carvalho de Melo wrote:
>
> Its possible that changes made to support non tracepoint events
> introduced this problem, so perhaps bisecting it, as this wasn't present
> some time ago, i.e. those big numbers :-\

git bisect failed miserably for me. But, pondering a bit on changes to 
the tracepoint processing and it's rather obvious - libtraceevent.

commit before libtraceevent - 44d1a3e -- works fine
first usable commit after libtraveevent - 8784eb7 -- fails


David
