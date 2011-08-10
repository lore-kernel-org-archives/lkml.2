Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1HJTeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:34:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1HJTeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:34:15 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=hJAYu0OxQsUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=yCox-ANtJ0YjFcxYf1QA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC 2/4] perf, ftrace: Add filter support for ftrace:function
 tracepoint
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
In-Reply-To: <1310390576-8289-3-git-send-email-jolsa@redhat.com>
References: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
	 <1310390576-8289-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 15:34:13 -0400
Message-ID: <1313004853.18583.263.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Sorry for the late response, I've been catching up on lots of other
things.


On Mon, 2011-07-11 at 15:22 +0200, Jiri Olsa wrote:

> +int ftrace_function_rec_ip(char *func, unsigned long long *ip)
> +{
> +	struct ftrace_page *pg;
> +	struct dyn_ftrace *rec;
> +	int len = strlen(func);
> +	int found = 0;
> +
> +	mutex_lock(&ftrace_lock);
> +
> +	do_for_each_ftrace_rec(pg, rec) {
> +		if (!ftrace_match_record(rec, NULL, func, len, MATCH_FULL))
> +			continue;
> +
> +		*ip = rec->ip;
> +		found = 1;
> +		break;

You can't use break here. The do_for_each_ftrace_rec() { }
while_for_each_ftrace_rec(); is a double loop. The break exits the first
loop, but then continues to the next loop. You must use a goto.

-- Steve

> +	} while_for_each_ftrace_rec();
> +
> +	mutex_unlock(&ftrace_lock);
> +
> +	return found ? 0 : -EINVAL;
> +}
> +


