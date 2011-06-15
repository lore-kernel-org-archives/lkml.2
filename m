Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1FOOnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:43:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33013 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab1FOOnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:43:11 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=HVDrj32HsC0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=VKIFrmZUb0aqFhlm8acA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 03/16 v2] tracing: Add a proc file to stop tracing and
 free buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
In-Reply-To: <20110615142523.GA17204@somewhere>
References: <20110615134841.767565350@goodmis.org>
	 <20110615135233.415290242@goodmis.org>  <20110615142523.GA17204@somewhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Jun 2011 10:43:09 -0400
Message-ID: <1308148989.9218.127.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 16:25 +0200, Frederic Weisbecker wrote:
> On Wed, Jun 15, 2011 at 09:48:44AM -0400, Steven Rostedt wrote:
> > From: Vaibhav Nagarnaik <vnagarnaik@google.com>
> > 
> > The proc file entry buffer_size_kb is used to set the size of tracing
> > buffer.
> >
> > The memory to expand the buffer size is kernel memory. Consider
> > a use case where tracing is handled by a user space utility, which acts
> > as a gate keeper for tracing requests. In an OOM condition, tracing is
> > considered a low priority task and if the utility gets killed the ring
> > buffer memory cannot be released back to the kernel.
> > 
> > This patch adds a proc file called "free_buffer" whose purpose is to
> > stop tracing and free up the ring buffer when it is closed.
> > 

> 
> s/proc/debugfs, right?

Oops, I didn't even notice it said that. But you are correct, the patch
adds a debugfs not a proc file.

Not sure it's worth redoing for the changelog though :-/

-- Steve



