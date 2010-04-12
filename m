Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0DLWLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 18:11:31 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64837 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0DLWLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 18:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AunyKRBER2p9Iy2pDj+Ln3/zkamTG8XC1/WQQtVPmlxs40aTj5FaDrdjWgRgcS26r8
         1l5UnaJEohPcruZUxZbKCbt9+LmqT4AGMhJnBqhk1zVbWn0Y0DPXaz5E7DI1TcfQXjtC
         Q2p+QYl8x/ieMww5M5trRxIIbTYLULgJ8G1OQ=
Date: Tue, 13 Apr 2010 00:04:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Anton Blanchard <anton@samba.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: TRACE_EVENT() declarations belong to include/trace/
Message-ID: <20100412220451.GG8285@nowhere>
References: <20100412214511.GA2699@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412214511.GA2699@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 05:45:11PM -0400, Mathieu Desnoyers wrote:
> Why are there TRACE_EVENT() declarations in arch/powerpc/include/asm/trace.h for
> irq_entry/exit ?
> 
> What's so special about them that they cannot be put in linux/trace/ ?
> 
> I'm all for the trace_irq_entry/exit instrumentation, but I don't see any good
> in adding event declarations outside of include/trace/.
> 
> Thanks,


Yeah,

If this is to trace all irqs, then it seems to me the wrong way.
We already have generic irq_handler_entry and irq_handler_exit trace events.

May be those in powerpc are here to get the spurious irqs by computing
a diff between generic and arch irq events? In which case
it would be better to get dedicated spurious irq tracepoints.

