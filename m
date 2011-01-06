Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1AFEez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 23:34:55 -0500
Received: from mail.perches.com ([173.55.12.10]:2986 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1AFEey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 23:34:54 -0500
Subject: Re: [PATCH 2/2] apic: Add print error interrupt reason
From: Joe Perches <joe@perches.com>
To: Youquan Song <youquan.song@intel.com>, Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, trenn@suse.de,
        kent.liu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
In-Reply-To: <1294284532-24285-3-git-send-email-youquan.song@intel.com>
References: <1294284532-24285-1-git-send-email-youquan.song@intel.com>
	 <1294284532-24285-2-git-send-email-youquan.song@intel.com>
	 <1294284532-24285-3-git-send-email-youquan.song@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 20:34:51 -0800
Message-ID: <1294288492.12561.46.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 11:28 +0800, Youquan Song wrote:
> End user worry about the error interrupt information and intend to know what
> kind of error interrupts are generated, so this patch add printing out the
> detail debug information of error interrupt. 
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
>  arch/x86/kernel/apic/apic.c |   28 +++++++++++++++++++++++++++-
>  1 files changed, 27 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
[]
> +static const char *error_interrupt_reason[] = {

static const char * const etc[]

> +	"Send CS error",
> +	"Receive CS error",
> +	"Send accept error",
> +	"Receive accept error",
> +	"Redirectable IPI",
> +	"Send illegal vector",
> +	"Received illegal vector",
> +	"Illegal register address",
> +};
> +
> +static void print_error_interrupt_reason(u32 reason)
> +{
> +	u32 i = 0;
> +	reason = reason & 0xff;
> +	do {
> +		if (reason & 0x1)
> +			pr_debug(" : %s", error_interrupt_reason[i]);

This isn't correct as it will emit <7> for each reason.

You want pr_cont surrounded by #ifdef DEBUG
or some new #define pr_debug_cont in printk.h
but that won't play well with dynamic_debug.

Jason?  Got a cure for this?


