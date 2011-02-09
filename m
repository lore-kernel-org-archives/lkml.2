Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1BIU2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:28:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45607 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1BIU2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:28:53 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=a8RJBVBYTi4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=m3xP_OClXX20T7yaKzwA:9 a=d36W2Ohk6414Fu8yF-e9NHiwi1EA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/4] ftrace: Add -mfentry to Makefile on function
 tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <20110209201029.772571775@goodmis.org>
References: <20110209200249.111932716@goodmis.org>
	 <20110209201029.772571775@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Feb 2011 15:28:52 -0500
Message-ID: <1297283332.23343.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 15:02 -0500, Steven Rostedt wrote:

>  ifdef CONFIG_FUNCTION_TRACER
> -KBUILD_CFLAGS	+= -pg
> +ifdef CONFIG_HAVE_FENTRY
> +CC_HAS_FENTRY	:= $(call cc-option, -mfentry -DCC_HAS_FENTRY)

I should include a thanks to H. Peter Anvin in the change log for
telling me about the cc-option trick.

-- Steve

> +endif
> +KBUILD_CFLAGS	+= -pg $(CC_HAS_FENTRY)
> +KBUILD_AFLAGS	+= $(CC_HAS_FENTRY)
>  ifdef CONFIG_DYNAMIC_FTRACE
>  	ifdef CONFIG_HAVE_C_RECORDMCOUNT
>  		BUILD_C_RECORDMCOUNT := y


