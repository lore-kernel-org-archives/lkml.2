Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1I1Taf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 15:30:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34500 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab1I1Tae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 15:30:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Wed, 28 Sep 2011 21:32:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110928145144.3d074db9aa9b6f858e0dc4fb@canb.auug.org.au> <201109281558.05289.rjw@sisk.pl> <CACVXFVMLBHu+CY1pgQnY04S_3iLN1z5S2vPiMdN6rsW=gBdWog@mail.gmail.com>
In-Reply-To: <CACVXFVMLBHu+CY1pgQnY04S_3iLN1z5S2vPiMdN6rsW=gBdWog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109282132.46887.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 28, 2011, Ming Lei wrote:
> Hi,
> 
> 2011/9/28 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Wednesday, September 28, 2011, Ming Lei wrote:
> >> Hi Stephen and Rafael,
> >>
> >> Sorry, the attachment patch can fix the build failure, which is
> >> caused by unset CONFIG_RUNTIME_PM.
> >
> > First off, that's CONFIG_PM_RUNTIME.  Second, why do you want to build
> > rpm-traces.c at all if CONFIG_PM_RUNTIME is unset?
> >
> 
> Yes, you are right,  follows the correct fix:
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 56bdab5..f49405f 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -53,7 +53,9 @@ endif
>  obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
>  obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
>  obj-$(CONFIG_TRACEPOINTS) += power-traces.o
> +ifeq ($(CONFIG_PM_RUNTIME),y)
>  obj-$(CONFIG_TRACEPOINTS) += rpm-traces.o
> +endif
>  ifeq ($(CONFIG_TRACING),y)
>  obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
>  endif

Well, this still is kind of ugly.  I'd prefer my patch sent in this thread.

Rafael
