Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1GYOCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:02:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57467 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1GYOCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:02:33 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=IpAmYfIOPbMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=hFEfRwvsN7kKOvoysmMA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=PNi3dE7MG_dqs0V-:21 a=zp1aArP8PYXdgwph:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 4/4] trace-cmd: Support '+' opcode in print format
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310785241-3799-4-git-send-email-vnagarnaik@google.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
	 <1310785241-3799-4-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 10:02:32 -0400
Message-ID: <1311602552.3526.17.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 20:00 -0700, Vaibhav Nagarnaik wrote:
> The '+' opcode is not supported in the arguments for the print format.
> This patch adds support for it.

Thanks! This was on my todo list.

-- Steve

> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  parse-events.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/parse-events.c b/parse-events.c
> index 068c77f..2e39415 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -2033,6 +2033,18 @@ static int arg_num_eval(struct print_arg *arg, long long *val)
>  				break;
>  			*val = left - right;
>  			break;
> +		case '+':
> +			if (arg->op.left->type == PRINT_NULL)
> +				left = 0;
> +			else
> +				ret = arg_num_eval(arg->op.left, &left);
> +			if (!ret)
> +				break;
> +			ret = arg_num_eval(arg->op.right, &right);
> +			if (!ret)
> +				break;
> +			*val = left + right;
> +			break;
>  		default:
>  			do_warning("unknown op '%s'", arg->op.op);
>  			ret = 0;


