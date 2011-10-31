Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1JaQPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 12:15:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41245 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1JaQPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 12:15:00 -0400
X-Authority-Analysis: v=1.1 cv=QqHiGEe6yGvmA2Hj/+B5Qdh2oWFRI3gWtdRZxD5t9t4= c=1 sm=0 a=D8-pIz8dYmQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=pGLkceISAAAA:8 a=iMa8qkZI-vdRCer3hXgA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320077699.4793.5.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: fix event_subsystem ref counting
From: Steven Rostedt <rostedt@goodmis.org>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 31 Oct 2011 12:14:59 -0400
In-Reply-To: <1320052062-7846-1-git-send-email-idryomov@gmail.com>
References: <1320052062-7846-1-git-send-email-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 11:07 +0200, Ilya Dryomov wrote:
> Fix a bug introduced by e9dbfae5, which prevents event_subsystem from
> ever being released.
> 
> Ref_count was added to keep track of subsystem users, not for counting
> events.  Subsystem is created with ref_count = 1, so there is no need to
> increment it for every event, we have nr_events for that.  Fix this by
> touching ref_count only when we actually have a new user -
> subsystem_open().

Good catch, I'll pull this in.

Thanks!

-- Steve

> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  kernel/trace/trace_events.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 581876f..c212a7f 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1078,7 +1078,6 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
>  	/* First see if we did not already create this dir */
>  	list_for_each_entry(system, &event_subsystems, list) {
>  		if (strcmp(system->name, name) == 0) {
> -			__get_system(system);
>  			system->nr_events++;
>  			return system->entry;
>  		}


