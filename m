Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2A0Doh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:44:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58365 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2A0Dog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:44:36 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=YuO6iUK6s4AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=1XWaLZrsAAAA:8 a=EorKjU_q1q5lnJhLIVMA:9 a=dAL0-QXJKEC28Mo1b-gA:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=rgnnYISA4vPIOHEU:21 a=_27H0uhkubJQHlsl:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327635873.22710.113.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace-cmd: fix length calculation for padding events
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, chavey@google.com,
        Gregory Haskins <gregory.haskins@gmail.com>
Date: Thu, 26 Jan 2012 22:44:33 -0500
In-Reply-To: <1327633215-4013-1-git-send-email-dhsharp@google.com>
References: <1327633215-4013-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 19:00 -0800, David Sharp wrote:
> Padding events store size in bytes, not words. Usually this ends up pushing
> the parser off the current page, but occasionally not, and when not,
> it ends up desynchronizing the parser from the event stream. This would
> manifest as a lot of "ug!" messages from trace-cmd, and kernelshark
> crashing before displaying the UI.
> 

Nice! Funny, Gregory (Cc'd) sent me a trace.dat file that exhibited this
behavior. I was going to look into it tomorrow. I tried it with this
patch and it makes the bug go away.

Nice catch!  I wonder how long this has been around without notice?
Probably from day one.

-- Steve

> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  trace-input.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/trace-input.c b/trace-input.c
> index e3157a7..b6af1e6 100644
> --- a/trace-input.c
> +++ b/trace-input.c
> @@ -1458,7 +1458,6 @@ translate_data(struct pevent *pevent,
>  	switch (type_len) {
>  	case RINGBUF_TYPE_PADDING:
>  		*length = data2host4(pevent, *ptr);
> -		*length *= 4;
>  		*ptr += *length;
>  		break;
>  


