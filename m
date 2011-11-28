Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1K1QTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:19:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53361 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab1K1QTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:19:22 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ajV93-eAzdgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=15bDEA6I8iNRf3S8aq4A:9 a=mwUCi62oQvL9hUXDF1YA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/9] trace: Fix uninitialized variable compiler warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
In-Reply-To: <1322417074-5834-2-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 11:19:18 -0500
Message-ID: <1322497158.17003.2.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-27 at 19:04 +0100, Jiri Olsa wrote:
> Initialize page2 variable to make compiler happy.

What compiler is this? Because this is a compiler bug. In fact, there's
no check for page2 being NULL, so if it is used uninitialized it will
crash the kernel. I don't like these "make the compiler shut up" fixes,
because honestly, changes like this hide bugs.

Nacked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 9e158cc..4a06862 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3655,8 +3655,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>  	struct page *pages[2];
>  	int nr_pages = 1;
>  	ssize_t written;
> -	void *page1;
> -	void *page2;
> +	void *page1, *page2 = NULL;
>  	int offset;
>  	int size;
>  	int len;


