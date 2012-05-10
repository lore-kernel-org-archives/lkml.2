Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab2EJWrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:47:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761692Ab2EJWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:46:59 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=g_LhDMiRcOYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=vhi3HUfkGJom_eI5vo8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336690016.14207.240.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>
Date: Thu, 10 May 2012 18:46:56 -0400
In-Reply-To: <4FAC2B3E.8000105@redhat.com>
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com>
	 <20120510204042.GA4598@aftab.osrc.amd.com> <4FAC2B3E.8000105@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 17:55 -0300, Mauro Carvalho Chehab wrote:

> >>  EXPORT_SYMBOL_GPL(edac_mc_handle_error);
> >> diff --git a/include/ras/hw_event.h b/include/ras/hw_event.h
> >> new file mode 100644
> >> index 0000000..66981ef
> >> --- /dev/null
> >> +++ b/include/ras/hw_event.h
> >> @@ -0,0 +1,77 @@
> >> +#undef TRACE_SYSTEM
> >> +#define TRACE_SYSTEM hw_event
> > 
> > 			ras
> 
> Then, the header name should be called as "ras.h", otherwise an error happens:
> 
> In file included from include/ras/hw_event.h:77:0,
>                  from drivers/edac/edac_mc.c:38:
> include/trace/define_trace.h:79:43: fatal error: ../../include/ras/ras.h: Arquivo ou diretório não encontrado

>From samples/trace_events/trace-events-sample.h:

/*
 * TRACE_INCLUDE_FILE is not needed if the filename and TRACE_SYSTEM are equal
 */
#define TRACE_INCLUDE_FILE trace-events-sample

Thus, you could do:

+++ b/include/ras/hw_event.h

+undef TRACE_SYSTEM
+define TRACE_SYSTEM ras

[...]

#define TRACE_INCLUDE_FILE hw_event


-- Steve


