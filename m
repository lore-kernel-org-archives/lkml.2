Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1CJVBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:01:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52306 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1CJVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:01:38 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=v1n8UvUeJUkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=g1NB5SIbZ9ZV3jjYr7kA:9 a=bVLw6h6wPMYOI2FX4aKhmr0FNUkA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] jump label: introduce static_branch() interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
References: <cover.1299702291.git.jbaron@redhat.com>
	 <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 16:01:35 -0500
Message-ID: <1299790895.15854.419.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 15:47 -0500, Jason Baron wrote:

> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index 961b6b3..dfa4c3c 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -4,13 +4,13 @@
>   * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
>   *
>   */
> -#include <linux/jump_label.h>
>  #include <linux/memory.h>
>  #include <linux/uaccess.h>
>  #include <linux/module.h>
>  #include <linux/list.h>
>  #include <linux/jhash.h>
>  #include <linux/cpu.h>
> +#include <linux/jump_label.h>
>  #include <asm/kprobes.h>
>  #include <asm/alternative.h>
>  
> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c

Jason,

I'm curious, is there a reason for this header change? Clean up? Maybe
it could go into a separate patch. If anything, just to make this one
slightly smaller.


-- Steve


