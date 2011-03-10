Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1CJOxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:53:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1CJOxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:53:39 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=22b6r0FicaIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=l5K6mMX47ewozwNn80AA:9 a=4qrcPZ4tJCix4sGHEcyjTQ3eoPAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/3]trace-cmd: remove dead code
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D78A0A4.1040001@cn.fujitsu.com>
References: <4D78A0A4.1040001@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 09:53:38 -0500
Message-ID: <1299768818.15854.343.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 17:57 +0800, Lai Jiangshan wrote:
> filter_cpu related code is totally dead.

I'll rephrase this, as it is not dead. "dead" code is code that can not
be reached. This code most certainly can be reached. You may think it is
silly code, which it may be. The reason for the separation of one CPU
and multiple CPUs, is I do one CPU more often than I filter multiple,
and I wanted the 1 cpu to still be efficient.

-- Steve

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  trace-read.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/trace-read.c b/trace-read.c
> index 0e9ced8..1cd9bd3 100644
> --- a/trace-read.c
> +++ b/trace-read.c
> @@ -73,7 +73,6 @@ static const char *input_file;
>  static int multi_inputs;
>  static int max_file_size;
>  
> -static int filter_cpu = -1;
>  static int *filter_cpus;
>  static int nr_filter_cpus;
>  
> @@ -619,10 +618,6 @@ get_next_record(struct handle_list *handles, int *next_cpu)
>  				record = tracecmd_read_data(handles->handle, next_cpu);
>  			else
>  				record = NULL;
> -
> -		} else if (filter_cpu >= 0) {
> -			cpu = filter_cpu;
> -			record = tracecmd_read_data(handles->handle, cpu);
>  		} else
>  			record = tracecmd_read_next_data(handles->handle, &cpu);
>  
> @@ -963,10 +958,7 @@ void trace_report (int argc, char **argv)
>  		case 0:
>  			switch(option_index) {
>  			case 0: /* cpu */
> -				if (filter_cpu)
> -					add_cpu(optarg);
> -				else
> -					filter_cpu = atoi(optarg);
> +				add_cpu(optarg);
>  				break;
>  			case 1: /* events */
>  				print_events = 1;


