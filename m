Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0CORgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 13:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0CORgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 13:36:33 -0400
Date: Mon, 15 Mar 2010 18:34:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [PATCH 1/2] kmod: add init function to usermodehelper
Message-ID: <20100315173454.GA7976@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315123355.GC16175@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315123355.GC16175@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Neil Horman wrote:
>
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -116,27 +116,16 @@ int __request_module(bool wait, const char *fmt, ...)
>
>  	trace_module_request(module_name, wait, _RET_IP_);
>
> -	ret = call_usermodehelper(modprobe_path, argv, envp,
> -			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
> +	ret = call_usermodehelper_fns(modprobe_path, argv, envp,
> +			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC,
> +			NULL, NULL, NULL);

This change looks unnecessary, but doesn't hurt.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

