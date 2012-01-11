Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab2AKRmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:42:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab2AKRmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:42:03 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=xKagQIkeoNUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=0XEA30vv-wYp-iRS3HMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326303721.7642.59.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 6/9] block: add block_touch_buffer tracepoint
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, mingo@redhat.com, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com
Date: Wed, 11 Jan 2012 12:42:01 -0500
In-Reply-To: <1326220106-5765-7-git-send-email-tj@kernel.org>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
	 <1326220106-5765-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 10:28 -0800, Tejun Heo wrote:
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/block.h>
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 458f497..245caed 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -13,6 +13,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/wait.h>
>  #include <linux/atomic.h>
> +#include <trace/events/block.h>

trace/events/x.h in a header can cause issue if this header is ever
included in another trace/events/x.h header. I think I'll need to write
a patch that allows this, but it wont be pretty.


-- Steve


