Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1BWNpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:45:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab1BWNpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:45:10 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=x7y_yQoqp1kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=t5I2HWEiPDRumVxpvbcA:9 a=tCP9KlncKT-hKH1TcAILaR_ulrYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] jump label: introduce static_branch() interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, hpa@zytor.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <1298455885.2217.354.camel@twins>
References: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
	 <1298455885.2217.354.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Feb 2011 08:45:06 -0500
Message-ID: <1298468706.7666.78.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 11:11 +0100, Peter Zijlstra wrote:
> On Tue, 2011-02-22 at 17:28 -0500, Jason Baron wrote:
> > @@ -33,7 +28,11 @@ struct _ddebug {
> >  #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using
> > the format */
> >  #define _DPRINTK_FLAGS_DEFAULT 0
> >         unsigned int flags:8;
> > -       char enabled;
> > +#ifdef HAVE_JUMP_LABEL
> > +       struct jump_label_key enabled;
> > +#else
> > +       int enabled;
> > +#endif
> >  } __attribute__((aligned(8)));
> >   
> 
> Also, didn't you promise Mathieu a comment explaining why dynamic debug
> does funny things like this? :-) I mean we all know its because of the
> cyclic header stuff involving atomic etc.. but I'm also quite sure we'll
> all have forgotten about that in a few weeks time.

Case in point.... I already forgot about that ;-)

-- Steve


