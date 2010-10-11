Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0JKUT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:19:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40733 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0JKUT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:19:57 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=eMo0_ZK51DsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=7V4X0x-WNm5p763ncRUA:9 a=7jEI01MDFHRUnlQqdWJeW0vwk9oA:4 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=F33b9BJ9xD91k3zQ:21 a=-i5Sj2Rr7_Nt18FK:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] plugin_kvm: fix kvm_exit rip formatting
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
In-Reply-To: <1286787515-13722-1-git-send-email-avi@redhat.com>
References: <1286787515-13722-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 16:19:53 -0400
Message-ID: <1286828393.4519.0.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 10:58 +0200, Avi Kivity wrote:
> %0xlx is not a valid printf format.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>

Applied, thanks!

-- Steve

> ---
>  plugin_kvm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/plugin_kvm.c b/plugin_kvm.c
> index cdd52c7..724143d 100644
> --- a/plugin_kvm.c
> +++ b/plugin_kvm.c
> @@ -153,7 +153,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct record *record,
>  
>  	trace_seq_printf(s, "reason %s", find_vmx_reason(val));
>  
> -	pevent_print_num_field(s, " rip %0xlx", event, "guest_rip", record, 1);
> +	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
>  
>  	return 0;
>  }


