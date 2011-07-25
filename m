Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1GYOBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:01:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40057 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1GYOBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:01:33 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=FR6zTIM_aIIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=MrVEkP_1E7Cya8FaWqAA:9 a=VPBv-g9cLLsIAbY0nb8A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/4] trace-cmd: Handle opcode parsing error
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310785241-3799-3-git-send-email-vnagarnaik@google.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
	 <1310785241-3799-3-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 10:01:31 -0400
Message-ID: <1311602491.3526.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 20:00 -0700, Vaibhav Nagarnaik wrote:
>  
>  /* Note, *tok does not get freed, but will most likely be saved */
> @@ -1706,7 +1706,10 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
>  		arg->op.op = token;
>  		arg->op.left = left;
>  
> -		set_op_prio(arg);
> +		if (-1 == set_op_prio(arg)) {

I'm fine with the patch up to here. I understand the constant first
compare, but it doesn't make sense here. Either use:

	if (set_op_prio(arg) < 0) ...
 or
	if (set_op_prio(arg) == -1)...


The reason the -1 == doesn't make sense is because:

	if (set_op_proi(arg) = -1)

would fail too.

And it is much easier to read.

-- Steve

> +			event->flags |= EVENT_FL_FAILED;
> +			goto out_free;
> +		}
>  
>  		type = read_token_item(&token);
>  		*tok = token;


