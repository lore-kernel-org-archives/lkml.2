Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2CMWdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:33:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab2CMWdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:33:35 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=GQe9zCMQTfAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=imeR3UVgisiY6QAHTEAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331678012.25686.666.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2012 18:33:32 -0400
In-Reply-To: <20120228145744.GG1694@m.brq.redhat.com>
References: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1330427423-25499-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <20120228145744.GG1694@m.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 15:57 +0100, Jiri Olsa wrote:
>  
> 
> ook, this one fixies that for me as well ;) I got your replies mixed in
> mailbox and thought this one was not actually working..
> 
> I also added this bit to get rid of the switch warnings,
> feel free to use it.
> 
> thanks,
> jirka

Can you send me your Signed-off-by for this too. Thanks.

-- Steve

> ---
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index dd478fc..5f3f3be 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -144,12 +144,14 @@ struct event_filter;
>  enum trace_reg {
>  	TRACE_REG_REGISTER,
>  	TRACE_REG_UNREGISTER,
> +#ifdef CONFIG_PERF_EVENTS
>  	TRACE_REG_PERF_REGISTER,
>  	TRACE_REG_PERF_UNREGISTER,
>  	TRACE_REG_PERF_OPEN,
>  	TRACE_REG_PERF_CLOSE,
>  	TRACE_REG_PERF_ADD,
>  	TRACE_REG_PERF_DEL,
> +#endif
>  };
>  
>  struct ftrace_event_call;


