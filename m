Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2ELDIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 23:08:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2ELDIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 23:08:06 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=lLL2lZuacRoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=YCgKsIjKAAAA:8 a=_B9tGATgDamWrVDCI7oA:9 a=cv0FsHo0zm6KwsT1FlIA:7 a=PUjeQqilurYA:10 a=f4FvcZ5phd4A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336792082.14207.262.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/1] kernel/trace: gcc warning: uninitialized variable.
From: Steven Rostedt <rostedt@goodmis.org>
To: Raphael Santana carvalho <utroz@oakcoders.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 11 May 2012 23:08:02 -0400
In-Reply-To: <CADeC0sNq41kGWw6JbASu6WE-SkTHihf9SnKCTaBTSyas4TJoMg@mail.gmail.com>
References: <CADeC0sNq41kGWw6JbASu6WE-SkTHihf9SnKCTaBTSyas4TJoMg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 23:26 -0300, Raphael Santana carvalho wrote:
> >From 2f1490c5e8e2a393d9376d959e2ff6836757f51a Mon Sep 17 00:00:00 2001
> From: Raphael S.Carvalho <utroz@oakcoders.com>
> Date: Fri, 11 May 2012 22:58:43 -0300
> Subject: [PATCH 1/1] kernel/trace: gcc warning: uninitialized variable.
> 
> I've received a problem in this file when I was compiling my own kernel.
> It's a simple uninitialized variable, so that gcc is warning about it.
> 
> The function is actually working correctly, because it's impossible to use the
> variable(page2) uninitialized because it's only referenced if nr_pages == 2,
> and we will have previously set it in that case.

Correct.

> 
> gcc version 4.5.2 (GCC) - Follows the warning:

It's a bug in gcc. If you use gcc 4.6 or later it does not warn.

As this code may change in the future, I don't want to hide errors that
gcc 4.6 could catch. Thus I'm not going to take this patch.

Don't feel bad, you're probably the 5th person I declined this change
from. At least you noticed that it was just gcc complaining and did not
blindly set the variable to NULL.

-- Steve

> kernel/trace/trace.c:3755:8 warning: 'page2': may be used uninitialized in this function
> 
> Signed-off-by: Raphael S.Carvalho <utroz@oakcoders.com>
> ---
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 2a22255..4ffff83 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3752,7 +3752,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>      int nr_pages = 1;
>      ssize_t written;
>      void *page1;
> -    void *page2;
> +    void *uninitialized_var(page2);
>      int offset;
>      int size;
>      int len;


