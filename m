Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897Ab2KBRx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:53:29 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:15395 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932260Ab2KBRx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:53:26 -0400
Date: Fri, 2 Nov 2012 17:53:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH 8/9] trace: use this_cpu_ptr per-cpu helper
In-Reply-To: <5093E5FF.5050000@gmail.com>
Message-ID: <0000013ac24187fb-694b1865-baeb-4e3b-970e-50bdcd631de7-000000@email.amazonses.com>
References: <50910A1E.3040009@gmail.com> <0000013ab7f1e47a-68c5ce3c-06bb-48f8-93f7-1ce012b36a75-000000@email.amazonses.com> <5093E5FF.5050000@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Shan Wei wrote:

> Christoph Lameter said, at 2012/11/1 1:50:
> >>
> >> -	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
> >> +	buffer = this_cpu_ptr(percpu_buffer);
> >>
> >>  	return buffer->buffer;
> >
> >
> > Just do a
> >
> > 	return this_cpu_read(percpu_buffer->buffer);
> >
> > and get rid of the this_cpu_ptr op
>
> can not do that.
> kernel/trace/trace.c:1515: error: incompatible types when assigning to type 'char[1024]' from type 'char *'

hmm.... what is actually returned is a pointer to char right? And buffer
is char[1024] so I guess then you need to pass a pointer to char to
this_cpu_read.

return this_cpu_read(&(percpu_buffer->buffer))
