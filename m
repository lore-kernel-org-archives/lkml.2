Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1AJQL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:11:29 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52017 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1AJQL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=t//6XH+a+oGn62ZcOL7QlOJkMKfHqRh0QLbO6DGFK7p0s7HQhUHlptsmKObick5HdA
         HgKKMsjDALpK86q1TAuKhCCs0JS549QawuChLXN8m4vwxVXxc8565/NzkGZIoR2hTsv3
         r7H8lmPyWk1BU28HZIyDBd8vbq1CXMFZLayew=
Date: Mon, 10 Jan 2011 14:11:16 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu
Subject: Re: [PATCH] tools/perf: use PTHREAD_STACK_MIN to avoid
 pthread_attr_setstacksize() fail
Message-ID: <20110110161116.GA18505@ghostprotocols.net>
References: <20110110160417.GB2685@psychotron.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110160417.GB2685@psychotron.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 10, 2011 at 05:04:18PM +0100, Jiri Pirko escreveu:
> on ppc64:
> /usr/include/bits/local_lim.h:#define PTHREAD_STACK_MIN	131072
> 
> therefore following set of commands:
> # perf sched record date
> # perf sched report
> 
> gives:
> perf.2.6.37test: builtin-sched.c:493: create_tasks: Assertion `!(err)' failed.
> 
> So make sure we do not set stack size lower than PTHREAD_STACK_MIN.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>

Thanks, applying.

- Arnaldo
