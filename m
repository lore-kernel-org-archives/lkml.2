Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab2EIOTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:19:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab2EIOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:19:20 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=aHbdvXMWeFoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=UnPqMEeQ6OuWPSe21tsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336573158.14207.206.camel@gandalf.stny.rr.com>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
From: Steven Rostedt <rostedt@goodmis.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>
Date: Wed, 09 May 2012 10:19:18 -0400
In-Reply-To: <4FAA7649.5080606@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
	 <1334608729-30803-5-git-send-email-mchehab@redhat.com>
	 <20120509121326.GA22737@aftab.osrc.amd.com> <4FAA6802.9070506@redhat.com>
	 <20120509132237.GD22737@aftab.osrc.amd.com> <4FAA7649.5080606@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 10:51 -0300, Mauro Carvalho Chehab wrote:
> Em 09-05-2012 10:22, Borislav Petkov escreveu:
> > + Tony.
> 
> C/C Steven.

Hehe, I was already Cc'd ;-)

> One other option would be to call it as "include/trace/events/ras.h".
> 
> Steven,
> 
> Would it be possible/recommendable to move this trace header
> to include/linux/ras/hw_event.h?

Yeah, it's not hard. In fact, it's documented in
samples/trace_events/trace-events-sample.h:

/*
 * There are several ways I could have done this. If I left out the
 * TRACE_INCLUDE_PATH, then it would default to the kernel source
 * include/trace/events directory.
 *
 * I could specify a path from the define_trace.h file back to this
 * file.
 *
 * #define TRACE_INCLUDE_PATH ../../samples/trace_events
 *
 * But the safest and easiest way to simply make it use the directory
 * that the file is in is to add in the Makefile:
 *
 * CFLAGS_trace-events-sample.o := -I$(src)
 *
 * This will make sure the current path is part of the include
 * structure for our file so that define_trace.h can find it.
 *
 * I could have made only the top level directory the include:
 *
 * CFLAGS_trace-events-sample.o := -I$(PWD)
 *
 * And then let the path to this directory be the TRACE_INCLUDE_PATH:
 *
 * #define TRACE_INCLUDE_PATH samples/trace_events
 *
 * But then if something defines "samples" or "trace_events" as a macro
 * then we could risk that being converted too, and give us an unexpected
 * result.
 */

But usually the header would go where the code is:

drivers/edac/hw_event.h

Or rename it. The XFS tracepoints do this:

fs/xfs/xfs_trace.h

-- Steve


