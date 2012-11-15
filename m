Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab2KOXLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:11:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25465 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2KOXLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:11:42 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_hlxZwuNuxYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=kQC1szw6xFsA:10 a=CKLZwLOsXKyUI4niKqQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353021100.9391.0.camel@gandalf.local.home>
Subject: Re: [PATCH] kernel-shark: Allow unsetting of all CPUs in filter
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 15 Nov 2012 18:11:40 -0500
In-Reply-To: <1353018498-3828-1-git-send-email-vnagarnaik@google.com>
References: <1353018498-3828-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 14:28 -0800, Vaibhav Nagarnaik wrote:

> +	else
> +		cpu_clear(cpu_helper->cpu_mask, cpu);
> +
> +	cpu_helper->allcpus = cpu_allset(cpu_helper->cpu_mask,
> +					 cpu_helper->cpus);
> +	/*
> +	 * Deactivate sending 'toggled' signal for "All CPUs"
> +	 * while we adjust its state
> +	 */
> +	g_signal_handlers_block_by_func(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu_helper->cpus]),
> +				        G_CALLBACK (cpu_toggle),
> +				        (gpointer) cpu_helper);

Kind of hacky, but it works.

Applied, Thanks!

-- Steve

>  
>  	gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu_helper->cpus]),
> -				     FALSE);
> +				     cpu_helper->allcpus);
> +
> +	g_signal_handlers_unblock_by_func(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu_helper->cpus]),
> +					  G_CALLBACK (cpu_toggle),
> +					  (gpointer) cpu_helper);
>  }
>  
>  /**


