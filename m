Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0LDILd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 03:11:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab0LDILc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 03:11:32 -0500
Message-ID: <4CF9F7AB.8050802@redhat.com>
Date: Sat, 04 Dec 2010 10:11:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mrubin@google.com,
        kvm-devel <kvm@vger.kernel.org>
Subject: Re: [PATCH 07/15] ftrace: fix event alignment: kvm:kvm_hv_hypercall
References: <1291421609-14665-1-git-send-email-dhsharp@google.com> <1291421609-14665-8-git-send-email-dhsharp@google.com>
In-Reply-To: <1291421609-14665-8-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2010 02:13 AM, David Sharp wrote:
> Signed-off-by: David Sharp<dhsharp@google.com>
> ---
>   arch/x86/kvm/trace.h |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index a6544b8..ab41fb0 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -62,21 +62,21 @@ TRACE_EVENT(kvm_hv_hypercall,
>   	TP_ARGS(code, fast, rep_cnt, rep_idx, ingpa, outgpa),
>
>   	TP_STRUCT__entry(
> -		__field(	__u16, 		code		)
> -		__field(	bool,		fast		)
>   		__field(	__u16,		rep_cnt		)
>   		__field(	__u16,		rep_idx		)
>   		__field(	__u64,		ingpa		)
>   		__field(	__u64,		outgpa		)
> +		__field(	__u16, 		code		)
> +		__field(	bool,		fast		)
>   	),
>

Looks like a pessimisation.

Before: 24 bytes
After: 32 bytes

(on a 64-bit machine, assuming no packing)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

