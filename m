Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2JQIT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:19:27 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52075 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2JQITZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:19:25 -0400
Message-ID: <507E6A01.1000500@linux.vnet.ibm.com>
Date: Wed, 17 Oct 2012 16:19:13 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, fweisbec@gmail.com,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/12] perf kvm: split out tracepoints from record args
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com> <1349716656-48165-10-git-send-email-dsahern@gmail.com>
In-Reply-To: <1349716656-48165-10-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101708-5490-0000-0000-0000024CED24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 01:17 AM, David Ahern wrote:

>  	unsigned int rec_argc, i, j;
>  	const char **rec_argv;
> +	const char * const record_args[] = {
> +		"record",
> +		"-R",
> +		"-f",
> +		"-m", "1024",
> +		"-c", "1",
> +	};
> 
> -	rec_argc = ARRAY_SIZE(record_args) + argc + 2;
> +	rec_argc = ARRAY_SIZE(record_args) + argc + 2 +
> +		   ARRAY_SIZE(kvm_events_tp);

Only calculate the size of tracepoints...

>  	rec_argv = calloc(rec_argc + 1, sizeof(char *));
> 
>  	if (rec_argv == NULL)
> @@ -818,6 +821,11 @@ static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
>  	for (i = 0; i < ARRAY_SIZE(record_args); i++)
>  		rec_argv[i] = STRDUP_FAIL_EXIT(record_args[i]);
> 
> +	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
> +		rec_argv[i++] = "-e";

Then you add "-e" into the array, however, it is calculated into rec_argc?
Or I missed something.

Other patches look good to me, thanks for your work and look forward to
the new version. :)

