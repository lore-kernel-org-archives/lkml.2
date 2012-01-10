Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab2AJBZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:25:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40245 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755753Ab2AJBZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:25:48 -0500
Message-ID: <4F0B9374.5010207@fb.com>
Date: Mon, 9 Jan 2012 17:25:08 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: <linux-kernel@vger.kernel.org>, <peterz@infradead.org>, <mingo@elte.hu>,
        <acme@infradead.org>, <robert.richter@amd.com>, <ming.m.lin@intel.com>,
        <andi@firstfloor.org>, <ravitillo@lbl.gov>, <vweaver1@eecs.utk.edu>
Subject: Re: [PATCH 11/13] perf: add code to support PERF_SAMPLE_BRANCH_STACK
 (v3)
References: <1326127761-2723-1-git-send-email-eranian@google.com> <1326127761-2723-12-git-send-email-eranian@google.com>
In-Reply-To: <1326127761-2723-12-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2012-01-09_06:2012-01-09,2012-01-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/12 8:49 AM, Stephane Eranian wrote:
> From: Roberto Agostino Vitillo<ravitillo@lbl.gov>
>
> This patch adds:
> - ability to parse samples with PERF_SAMPLE_BRANCH_STACK
> - sort on branches
> - build histograms on branches
>
[..]
>   static struct sort_dimension sort_dimensions[] = {
> -	{ .name = "pid",	.entry =&sort_thread,	},
> -	{ .name = "comm",	.entry =&sort_comm,	},
> -	{ .name = "dso",	.entry =&sort_dso,	},
> -	{ .name = "symbol",	.entry =&sort_sym,	},
> -	{ .name = "parent",	.entry =&sort_parent,	},
> -	{ .name = "cpu",	.entry =&sort_cpu,	},
> +	{ .name = "pid",	.entry =&sort_thread,			},
> +	{ .name = "comm",	.entry =&sort_comm,			},
> +	{ .name = "dso",	.entry =&sort_dso,			},
> +	{ .name = "dso_from",	.entry =&sort_dso_from,.taken = true	},
> +	{ .name = "dso_to",	.entry =&sort_dso_to,	.taken = true	},
> +	{ .name = "symbol",	.entry =&sort_sym,			},
> +	{ .name = "symbol_from",.entry =&sort_sym_from,.taken = true	},
> +	{ .name = "symbol_to",	.entry =&sort_sym_to,	.taken = true	},
> +	{ .name = "parent",	.entry =&sort_parent,			},
> +	{ .name = "cpu",	.entry =&sort_cpu,			},
> +	{ .name = "mispredict", .entry =&sort_mispredict, },
>   };

The new sort dimensions don't seem to show up in perf report -h. Could 
you please update the help text?

Also:

# perf script -h

     -f, --fields <str>    comma separated output fields prepend with 
'type:'. Valid types: hw,sw,trace,raw. Fields: 
comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr

You probably want to add a field here, so I could:

perf record -b any_call,u -e cycles:u
perf script -f event,branch_stack

and examine raw (symbolized) samples like I can with

perf record -g
perf script -f event,ip,sym

  -Arun

