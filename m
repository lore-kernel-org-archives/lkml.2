Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0LDBtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 20:49:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0LDBtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 20:49:12 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=FKmPEgYRmMMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=hu0TL-BFrgT-TbDs3LwA:9 a=MwPeXE8VPGugYru8eenztLt7GicA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 07/15] ftrace: fix event alignment: kvm:kvm_hv_hypercall
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
In-Reply-To: <1291421609-14665-8-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-8-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 20:49:10 -0500
Message-ID: <1291427350.16223.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Ccing Marcelo and Avi for Acked-by's ]

-- Steve


On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  arch/x86/kvm/trace.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index a6544b8..ab41fb0 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -62,21 +62,21 @@ TRACE_EVENT(kvm_hv_hypercall,
>  	TP_ARGS(code, fast, rep_cnt, rep_idx, ingpa, outgpa),
>  
>  	TP_STRUCT__entry(
> -		__field(	__u16, 		code		)
> -		__field(	bool,		fast		)
>  		__field(	__u16,		rep_cnt		)
>  		__field(	__u16,		rep_idx		)
>  		__field(	__u64,		ingpa		)
>  		__field(	__u64,		outgpa		)
> +		__field(	__u16, 		code		)
> +		__field(	bool,		fast		)
>  	),
>  
>  	TP_fast_assign(
> -		__entry->code		= code;
> -		__entry->fast		= fast;
>  		__entry->rep_cnt	= rep_cnt;
>  		__entry->rep_idx	= rep_idx;
>  		__entry->ingpa		= ingpa;
>  		__entry->outgpa		= outgpa;
> +		__entry->code		= code;
> +		__entry->fast		= fast;
>  	),
>  
>  	TP_printk("code 0x%x %s cnt 0x%x idx 0x%x in 0x%llx out 0x%llx",


