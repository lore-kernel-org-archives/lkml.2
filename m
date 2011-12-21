Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1LUWIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 17:08:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52944 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1LUWIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 17:08:02 -0500
Date: Wed, 21 Dec 2011 23:07:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 7/7] ftrace, perf: Add filter support for function trace
 event
Message-ID: <20111221220756.GL17668@somewhere>
References: <1324468136-3997-1-git-send-email-jolsa@redhat.com>
 <1324493791-5688-1-git-send-email-jolsa@redhat.com>
 <1324493791-5688-8-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324493791-5688-8-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 07:56:31PM +0100, Jiri Olsa wrote:
> Adding support to filter function trace event via perf
> interface. It is now possible to use filter interface
> in the perf tool like:
> 
>   perf record -e ftrace:function --filter="(ip == mm_*)" ls
> 
> The filter syntax is restricted to the the 'ip' field only,
> and following operators are accepted '==' '!=' '||', ending
> up with the filter strings like:
> 
>   "ip == f1 f2 ..." || "ip != f3 f4 ..." ...

Having the functions seperated like this sort of violates the
grammar of the filtering interface.

The typical way to do this would have been to stringify the
functions: ip == "f1 f2"

I feel a bit uncomfortable with "ip == f1 f2" scheme but perhaps
we can live with that. Especially as otherwise that would
require us to type "ip == \"f1 f2\"" for the whole filtering expression.

Thoughts?
